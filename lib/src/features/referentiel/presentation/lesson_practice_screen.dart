import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/quiz_generator_service.dart';
import '../application/referentiel_controllers.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/text_normalizer.dart';

class LessonPracticeScreen extends ConsumerStatefulWidget {
  final int lessonId;
  final GrammarLessonRecord? previewLesson;

  const LessonPracticeScreen({
    super.key,
    required this.lessonId,
    this.previewLesson,
  });

  @override
  ConsumerState<LessonPracticeScreen> createState() => _LessonPracticeScreenState();
}

class _LessonPracticeScreenState extends ConsumerState<LessonPracticeScreen> {
  final TextEditingController _answerCtrl = TextEditingController();
  bool _loaded = false;
  List<QuizQuestionItem> _questions = [];
  String _langCode = 'fr';
  int _index = 0;
  AnswerEvaluation? _evaluation;
  String? _selectedQcm;
  final Map<String, ExerciseResult> _results = {};
  double _totalPoints = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSession() async {
    final repo = ref.read(referentielRepositoryProvider);
    final lesson = widget.previewLesson ?? await repo.getLessonById(widget.lessonId);
    if (lesson == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }
    final lang = await repo.getLanguageById(lesson.langId);
    if (lang == null) {
      if (mounted) setState(() => _loaded = true);
      return;
    }

    final verbs = <ConjugationRecord>[];
    for (final id in lesson.linkedVerbIds) {
      final v = await repo.getConjugationById(id);
      if (v != null) verbs.add(v);
    }
    final decls = <DeclensionRecord>[];
    for (final id in lesson.linkedDeclensionIds) {
      final d = await repo.getDeclensionById(id);
      if (d != null) decls.add(d);
    }

    final items = QuizGeneratorService.buildLessonSession(
      lesson: lesson,
      profile: lang.grammarProfile,
      linkedVerbs: verbs,
      linkedDeclensions: decls,
    );

    if (mounted) {
      setState(() {
        _langCode = lang.code;
        _questions = items;
        _loaded = true;
      });
    }
  }

  void _submitAnswer(String rawInput) {
    if (_evaluation != null || _questions.isEmpty) return;
    final q = _questions[_index];
    final eval = TextNormalizer.evaluateAnswer(
      input: rawInput,
      expected: q.answer,
      acceptedAnswers: q.acceptedAnswers,
      variants: q.variants,
      langCode: _langCode,
    );

    setState(() {
      _evaluation = eval;
      _totalPoints += eval.status.points;
      _results[q.id] = ExerciseResult(
        score: eval.status.points,
        attempts: 1,
        lastAt: DateTime.now(),
      );
    });
  }

  Future<void> _nextQuestion() async {
    if (_index + 1 < _questions.length) {
      setState(() {
        _index++;
        _evaluation = null;
        _selectedQcm = null;
        _answerCtrl.clear();
      });
      return;
    }

    if (widget.previewLesson == null && _questions.isNotEmpty) {
      final repo = ref.read(referentielRepositoryProvider);
      await repo.saveLessonSessionResult(
        lessonId: widget.lessonId,
        newResults: _results,
        totalCount: _questions.length,
      );
      ref.invalidate(lessonProgressMapProvider);
    }

    if (mounted) {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('ENTRAÎNEMENT')),
        body: Center(child: CircularProgressIndicator(color: b.slate)),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('ENTRAÎNEMENT')),
        body: const Center(child: Text('Aucun exercice disponible pour cette leçon.')),
      );
    }

    if (_finished) {
      final pct = ((_totalPoints / _questions.length) * 100).round();
      return Scaffold(
        appBar: AppBar(title: const Text('RÉSULTATS')),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: b.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: b.slate, width: 1.5),
              boxShadow: [BoxShadow(color: b.slate, offset: const Offset(3, 3), blurRadius: 0)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$pct%', style: t.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Score : ${_totalPoints.toStringAsFixed(1)} / ${_questions.length}',
                  style: t.titleMedium,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: const Text('TERMINER'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EXERCICE ${_index + 1}/${_questions.length}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BauhausProgress(done: _index, total: _questions.length),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: b.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: b.slate, width: 1.5),
              boxShadow: [BoxShadow(color: b.slate, offset: const Offset(3, 3), blurRadius: 0)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: q.isGenerated ? b.pastelBlue.withValues(alpha: 0.3) : b.pastelYellow,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: b.slate, width: 1),
                      ),
                      child: Text(
                        q.isGenerated ? 'QUIZ DYNAMIQUE' : q.type.labelFr.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (q.isIrregular) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: b.pastelRed.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: b.slate, width: 1),
                        ),
                        child: const Text(
                          'IRRÉGULIER',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(q.prompt, style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                if (q.sentenceBefore.isNotEmpty || q.sentenceAfter.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: b.chalk,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: b.lineGrey, width: 1.2),
                    ),
                    child: Text(
                      '${q.sentenceBefore}______${q.sentenceAfter}',
                      style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (q.type == LessonExerciseType.qcm && q.qcmOptions.isNotEmpty)
            ...q.qcmOptions.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: _selectedQcm == opt ? b.pastelYellow : b.cardSurface,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: _evaluation == null
                      ? () {
                          setState(() => _selectedQcm = opt);
                          _submitAnswer(opt);
                        }
                      : null,
                  child: Text(opt),
                ),
              ),
            )
          else ...[
            TextField(
              controller: _answerCtrl,
              enabled: _evaluation == null,
              decoration: const InputDecoration(
                labelText: 'Votre réponse',
                hintText: 'Saisir la forme exacte...',
              ),
              onSubmitted: (val) => _submitAnswer(val),
            ),
            const SizedBox(height: 12),
            if (_evaluation == null)
              FilledButton(
                onPressed: () => _submitAnswer(_answerCtrl.text),
                child: const Text('VALIDER'),
              ),
          ],
          if (_evaluation != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: switch (_evaluation!.status) {
                  AnswerStatus.correct => b.pastelMint.withValues(alpha: 0.4),
                  AnswerStatus.almost => b.pastelYellow.withValues(alpha: 0.45),
                  AnswerStatus.wrong => b.pastelRed.withValues(alpha: 0.3),
                },
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: b.slate, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _evaluation!.feedback,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  if (_evaluation!.isWrong) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Réponse attendue : ${q.answer}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (q.explanation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(q.explanation),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: _nextQuestion,
              child: Text(_index + 1 < _questions.length ? 'SUIVANT' : 'VOIR LE SCORE'),
            ),
          ],
        ],
      ),
    );
  }
}
