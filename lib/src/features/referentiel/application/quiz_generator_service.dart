import 'dart:math';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';
import '../domain/text_normalizer.dart';
import 'pronoun_renderer.dart';

class QuizQuestionItem {
  final String id;
  final LessonExerciseType type;
  final String prompt;
  final String sentenceBefore;
  final String sentenceAfter;
  final String answer;
  final List<String> acceptedAnswers;
  final List<String> variants;
  final List<String> qcmOptions;
  final String explanation;
  final bool isGenerated;
  final bool isIrregular;

  const QuizQuestionItem({
    required this.id,
    required this.type,
    required this.prompt,
    this.sentenceBefore = '',
    this.sentenceAfter = '',
    required this.answer,
    this.acceptedAnswers = const [],
    this.variants = const [],
    this.qcmOptions = const [],
    this.explanation = '',
    this.isGenerated = false,
    this.isIrregular = false,
  });
}

class QuizGeneratorService {
  QuizGeneratorService._();

  /// Construit la file d'entraînement hybride (§4.3) :
  /// 1. Exercices contextualisés rédigés dans la leçon
  /// 2. Questions générées à la volée depuis `linked_verbs × target_tenses` et `linked_declensions × target_cases`
  static List<QuizQuestionItem> buildLessonSession({
    required GrammarLessonRecord lesson,
    required GrammarProfile profile,
    required List<ConjugationRecord> linkedVerbs,
    required List<DeclensionRecord> linkedDeclensions,
    int maxGenerated = 6,
    Random? random,
  }) {
    final rng = random ?? Random(42);
    final items = <QuizQuestionItem>[];

    // 1. Exercices rédigés
    for (final ex in lesson.exercises) {
      final options = ex.type == LessonExerciseType.qcm
          ? _deduplicatedOptions(
              answer: ex.answer,
              candidates: ex.distractors,
              variants: ex.acceptedAnswers,
              rng: rng,
            )
          : const <String>[];
      items.add(
        QuizQuestionItem(
          id: ex.id,
          type: ex.type,
          prompt: ex.promptText(),
          sentenceBefore: ex.sentenceBefore,
          sentenceAfter: ex.sentenceAfter,
          answer: ex.answer,
          acceptedAnswers: ex.acceptedAnswers,
          qcmOptions: options,
          explanation: ex.explanationText(),
          isGenerated: false,
        ),
      );
    }

    // 2. Questions générées (verbes puis déclinaisons)
    final generated = <QuizQuestionItem>[
      ..._generateVerbQuestions(
        verbs: linkedVerbs,
        targetTenses: lesson.targetTenses,
        profile: profile,
        rng: rng,
      ),
      ..._generateDeclensionQuestions(
        declensions: linkedDeclensions,
        targetCases: lesson.targetCases,
        profile: profile,
        rng: rng,
      ),
    ];

    // Prioriser les formes irrégulières
    generated.sort((a, b) {
      if (a.isIrregular != b.isIrregular) return a.isIrregular ? -1 : 1;
      return a.id.compareTo(b.id);
    });

    items.addAll(generated.take(maxGenerated));
    return items;
  }

  static List<QuizQuestionItem> _generateVerbQuestions({
    required List<ConjugationRecord> verbs,
    required List<TargetTense> targetTenses,
    required GrammarProfile profile,
    required Random rng,
  }) {
    final out = <QuizQuestionItem>[];
    for (final verb in verbs) {
      final candidateForms = verb.forms.where((f) {
        if (f.form.trim().isEmpty) return false;
        if (targetTenses.isEmpty) return true;
        return targetTenses.any((t) => t.mood == f.mood && t.tense == f.tense);
      }).toList();

      if (candidateForms.isEmpty) continue;

      // Trier irrégulières d'abord
      candidateForms.sort((a, b) {
        if (a.isIrregular != b.isIrregular) return a.isIrregular ? -1 : 1;
        return 0;
      });

      for (final f in candidateForms.take(3)) {
        final paradigm = profile.findVerbParadigm(f.mood, f.tense);
        final tenseLabel = paradigm?.label() ?? '${f.mood} ${f.tense}';
        final slotLabel = _describeVerbSlot(f, profile);

        // Si pronominal avec pronoun + bare_form, cibler tantôt le pronom tantôt le verbe
        final targetPronoun = verb.isPronominal &&
            f.pronoun != null &&
            f.bareForm != null &&
            rng.nextBool();

        final answer = targetPronoun ? f.pronoun! : f.form;
        final before = targetPronoun ? '' : _subjectPrefix(f, profile);
        final after = targetPronoun ? ' ${f.bareForm}' : '';

        final distractorPool = verb.forms
            .where((other) => other != f)
            .map((other) => targetPronoun ? (other.pronoun ?? other.form) : other.form)
            .toList();

        final options = _deduplicatedOptions(
          answer: answer,
          candidates: distractorPool,
          variants: targetPronoun ? const [] : f.variants,
          rng: rng,
        );

        final type = options.length >= 2 ? LessonExerciseType.qcm : LessonExerciseType.cloze;
        out.add(
          QuizQuestionItem(
            id: 'gen_v_${verb.id}_${f.mood}_${f.tense}_${f.dimensions.values.join('_')}',
            type: type,
            prompt: '${verb.lemma} — $tenseLabel ($slotLabel)',
            sentenceBefore: before,
            sentenceAfter: after,
            answer: answer,
            variants: targetPronoun ? const [] : f.variants,
            qcmOptions: type == LessonExerciseType.qcm ? options : const [],
            explanation: f.exceptionNote?['fr'] ??
                'Forme attendue : ${PronounRenderer.renderSubjectWithForm(f, profile)}',
            isGenerated: true,
            isIrregular: f.isIrregular || verb.isIrregular,
          ),
        );
      }
    }
    return out;
  }

  static List<QuizQuestionItem> _generateDeclensionQuestions({
    required List<DeclensionRecord> declensions,
    required List<String> targetCases,
    required GrammarProfile profile,
    required Random rng,
  }) {
    final out = <QuizQuestionItem>[];
    for (final decl in declensions) {
      if (decl.isInvariable && decl.forms.length <= 1) continue;

      final candidateForms = decl.forms.where((f) {
        if (f.form.trim().isEmpty) return false;
        if (targetCases.isEmpty) return true;
        return f.caseCode != null && targetCases.contains(f.caseCode);
      }).toList();

      if (candidateForms.isEmpty) continue;

      candidateForms.sort((a, b) {
        if (a.isIrregular != b.isIrregular) return a.isIrregular ? -1 : 1;
        return 0;
      });

      for (final f in candidateForms.take(3)) {
        final hasArticlePair = f.article != null &&
            f.article!.isNotEmpty &&
            f.bareForm != null &&
            f.bareForm!.isNotEmpty;

        final answer = hasArticlePair ? f.article! : f.form;
        final after = hasArticlePair ? ' ${f.bareForm}' : '';

        final distractorPool = decl.forms
            .where((other) => other != f)
            .map((other) => hasArticlePair ? (other.article ?? other.form) : other.form)
            .toList();

        final options = _deduplicatedOptions(
          answer: answer,
          candidates: distractorPool,
          variants: hasArticlePair ? const [] : f.variants,
          rng: rng,
        );

        final caseLabel = f.caseCode != null ? profile.caseLabel(f.caseCode!) : '';
        final metaParts = <String>[
          if (caseLabel.isNotEmpty) caseLabel,
          if (f.number != null) f.number!,
          if (f.gender != null) f.gender!,
          if (f.definiteness != null) f.definiteness!,
        ];

        final type = options.length >= 2 ? LessonExerciseType.qcm : LessonExerciseType.cloze;
        out.add(
          QuizQuestionItem(
            id: 'gen_d_${decl.id}_${f.dimensions.values.join('_')}',
            type: type,
            prompt: '${decl.lemma} (${decl.pos.code}) — ${metaParts.join(' · ')}',
            sentenceBefore: '',
            sentenceAfter: after,
            answer: answer,
            variants: hasArticlePair ? const [] : f.variants,
            qcmOptions: type == LessonExerciseType.qcm ? options : const [],
            explanation: f.exceptionNote?['fr'] ?? 'Forme attendue : ${f.form}',
            isGenerated: true,
            isIrregular: f.isIrregular || decl.isIrregular,
          ),
        );
      }
    }
    return out;
  }

  /// Dédoublonnage strict (§4.3) : exclut toute forme dont la valeur normalisée
  /// correspond à `answer` ou à l'une de ses `variants`, et déduplique les distracteurs.
  static List<String> _deduplicatedOptions({
    required String answer,
    required List<String> candidates,
    List<String> variants = const [],
    required Random rng,
  }) {
    final excluded = <String>{
      TextNormalizer.normalizeForComparison(answer),
      ...variants.map(TextNormalizer.normalizeForComparison),
    };
    final seen = <String>{...excluded};
    final distractors = <String>[];

    for (final c in candidates) {
      final norm = TextNormalizer.normalizeForComparison(c);
      if (norm.isEmpty || seen.contains(norm)) continue;
      seen.add(norm);
      distractors.add(c);
    }

    distractors.shuffle(rng);
    final options = <String>[answer, ...distractors.take(3)];
    options.shuffle(rng);
    return options;
  }

  static String _subjectPrefix(ConjugationForm form, GrammarProfile profile) {
    if (form.mood == 'IMP' || form.mood == 'PART') return '';
    final pronouns = profile.subjectPronouns;
    if (pronouns == null) return '';
    final p = form.person;
    final n = form.number;
    if (p == null || n == null) return '';
    final spec = pronouns['${p}_$n'];
    if (spec == null) return '';
    return '${spec.form} ';
  }

  static String _describeVerbSlot(ConjugationForm f, GrammarProfile profile) {
    if (f.mood == 'PART') return 'participe';
    final p = f.person;
    final n = f.number;
    if (p == 'OTHER') return 'autres personnes';
    if (p != null && n != null) {
      final pron = profile.subjectPronouns?['${p}_$n']?.form;
      return pron != null ? '$p$n ($pron)' : '$p $n';
    }
    return f.dimensions.values.join(' ');
  }
}
