import 'conjugation.dart';
import 'declension.dart';
import 'grammar_lesson.dart';
import 'grammar_profile.dart';
import 'text_normalizer.dart';

class ValidationIssue {
  final String entity;
  final String message;
  final bool isBlocking;

  const ValidationIssue({
    required this.entity,
    required this.message,
    this.isBlocking = true,
  });

  @override
  String toString() => '[$entity] $message';
}

class BundleValidationResult {
  final List<ValidationIssue> errors;
  final List<ValidationIssue> warnings;

  const BundleValidationResult({
    this.errors = const [],
    this.warnings = const [],
  });

  bool get isValid => errors.isEmpty;
}

class BundleValidator {
  BundleValidator._();

  static final RegExp _asciiSlugRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
  static final RegExp _linkedDeclensionRefRegex = RegExp(r'^[^#]+#(NOUN|ADJ|DET)$');
  static const Set<String> _validLevels = {'A1', 'A2', 'B1', 'B2', 'C1', 'C2'};

  static BundleValidationResult validateBundle({
    required Map<String, dynamic> bundle,
    required LanguageRecord language,
    Map<String, List<String>> existingPrerequisiteSlugsBySlug = const {},
  }) {
    final errors = <ValidationIssue>[];
    final warnings = <ValidationIssue>[];
    final profile = language.grammarProfile;

    final schemaVersion = bundle['schema_version']?.toString();
    if (schemaVersion != '1.3') {
      errors.add(ValidationIssue(
        entity: 'bundle',
        message: 'schema_version invalide ("$schemaVersion"), attendu "1.3".',
      ));
    }

    final bundleLang = bundle['lang']?.toString().trim().toLowerCase();
    if (bundleLang != language.code.toLowerCase()) {
      errors.add(ValidationIssue(
        entity: 'bundle',
        message: 'Langue du bundle ("$bundleLang") différente de "${language.code}".',
      ));
    }

    final rawConjugations = bundle['conjugations'] as List? ?? const [];
    final rawDeclensions = bundle['declensions'] as List? ?? const [];
    final rawLessons = bundle['lessons'] as List? ?? const [];

    if (!profile.hasDeclensions && rawDeclensions.isNotEmpty) {
      errors.add(ValidationIssue(
        entity: 'declensions',
        message: 'La langue "${language.code}" a has_declensions == false : déclinaisons refusées.',
      ));
    }

    // 1. Validate conjugations
    for (final raw in rawConjugations) {
      if (raw is! Map) {
        errors.add(const ValidationIssue(entity: 'conjugations', message: 'Entrée non-objet.'));
        continue;
      }
      final map = Map<String, dynamic>.from(raw);
      final lemma = TextNormalizer.normalize(map['lemma']?.toString() ?? '');
      if (lemma.isEmpty) {
        errors.add(const ValidationIssue(entity: 'conjugations', message: 'lemma manquant.'));
        continue;
      }
      final auxiliaries = profile.hasAuxiliaries
          ? List<String>.from(map['auxiliaries'] as List? ?? const [])
              .map(TextNormalizer.normalize)
              .toList()
          : const <String>[];
      final isDefective = (map['is_defective'] as bool?) ?? false;
      final formsRaw = map['forms'] as List? ?? const [];
      final seenKeys = <String>{};
      final filledSlots = <String>{};

      for (final fRaw in formsRaw) {
        if (fRaw is! Map) continue;
        final form = ConjugationForm.fromJson(Map<String, dynamic>.from(fRaw)).normalized();
        final paradigm = profile.findVerbParadigm(form.mood, form.tense);
        if (paradigm == null) {
          errors.add(ValidationIssue(
            entity: 'conjugation:$lemma',
            message: 'Paradigme inconnu (${form.mood}, ${form.tense}).',
          ));
          continue;
        }

        // Dimensions check (matching paradigm.dimensions or declared slots)
        final dimError = _validateVerbFormDimensions(form, paradigm);
        if (dimError != null) {
          errors.add(ValidationIssue(entity: 'conjugation:$lemma', message: dimError));
          continue;
        }

        // Auxiliary consistency
        if (form.auxiliary != null && !auxiliaries.contains(form.auxiliary)) {
          errors.add(ValidationIssue(
            entity: 'conjugation:$lemma',
            message: 'Auxiliaire "${form.auxiliary}" absent de auxiliaries $auxiliaries.',
          ));
        }

        // Pronoun / bare_form pair
        final hasPronoun = form.pronoun != null && form.pronoun!.isNotEmpty;
        final hasBare = form.bareForm != null && form.bareForm!.isNotEmpty;
        if (hasPronoun != hasBare) {
          errors.add(ValidationIssue(
            entity: 'conjugation:$lemma',
            message: 'pronoun et bare_form doivent être tous deux présents ou absents (${form.form}).',
          ));
        }

        // Dynamic uniqueness key
        final uKey = form.uniquenessKey(paradigm, auxiliaries.length);
        if (!seenKeys.add(uKey)) {
          errors.add(ValidationIssue(
            entity: 'conjugation:$lemma',
            message: 'Doublon détecté sur la clé d\'unicité dynamique ($uKey).',
          ));
        }
        filledSlots.add(form.slotKey(paradigm));
      }

      if (!isDefective && formsRaw.isNotEmpty) {
        final missing = <String>[];
        for (final p in profile.paradigms) {
          for (final slot in p.expectedSlots(profile)) {
            final key = ConjugationForm.buildSlotKey(p.mood, p.tense, p, slot);
            if (!filledSlots.contains(key)) {
              missing.add(key);
            }
          }
        }
        if (missing.isNotEmpty) {
          warnings.add(ValidationIssue(
            entity: 'conjugation:$lemma',
            message: '${missing.length} case(s) manquante(s) par rapport aux paradigmes.',
            isBlocking: false,
          ));
        }
      }
    }

    // 2. Validate declensions
    if (profile.hasDeclensions) {
      for (final raw in rawDeclensions) {
        if (raw is! Map) {
          errors.add(const ValidationIssue(entity: 'declensions', message: 'Entrée non-objet.'));
          continue;
        }
        final map = Map<String, dynamic>.from(raw);
        final lemma = TextNormalizer.normalize(map['lemma']?.toString() ?? '');
        final pos = DeclensionPos.tryParse(map['pos']?.toString());
        if (lemma.isEmpty || pos == null) {
          errors.add(ValidationIssue(
            entity: 'declension:${lemma.isEmpty ? '?' : lemma}',
            message: 'lemma ou pos invalide (attendu NOUN, ADJ ou DET).',
          ));
          continue;
        }

        final paradigm = profile.findDeclensionParadigm(pos.code);
        if (paradigm == null) {
          errors.add(ValidationIssue(
            entity: 'declension:$lemma#${pos.code}',
            message: 'Aucun declension_paradigm déclaré pour pos=${pos.code}.',
          ));
          continue;
        }

        final declClass = map['declension_class'] as String?;
        if (pos != DeclensionPos.noun && declClass != null && declClass.trim().isNotEmpty) {
          errors.add(ValidationIssue(
            entity: 'declension:$lemma#${pos.code}',
            message: 'declension_class doit être null pour pos=${pos.code} (réservé aux NOUN).',
          ));
        }

        final isInvariable = (map['is_invariable'] as bool?) ?? false;
        final formsRaw = map['forms'] as List? ?? const [];
        final seenKeys = <String>{};
        final filledSlots = <String>{};

        for (final fRaw in formsRaw) {
          if (fRaw is! Map) continue;
          final form = DeclensionForm.fromJson(Map<String, dynamic>.from(fRaw)).normalized();

          final dimError = _validateDeclensionFormDimensions(form, paradigm, profile);
          if (dimError != null) {
            errors.add(ValidationIssue(
              entity: 'declension:$lemma#${pos.code}',
              message: dimError,
            ));
            continue;
          }

          final hasArticle = form.article != null && form.article!.isNotEmpty;
          final hasBare = form.bareForm != null && form.bareForm!.isNotEmpty;
          if (hasArticle != hasBare) {
            errors.add(ValidationIssue(
              entity: 'declension:$lemma#${pos.code}',
              message: 'article et bare_form doivent être tous deux présents ou absents (${form.form}).',
            ));
          }

          final uKey = form.uniquenessKey(paradigm);
          if (!seenKeys.add(uKey)) {
            errors.add(ValidationIssue(
              entity: 'declension:$lemma#${pos.code}',
              message: 'Doublon détecté sur la clé d\'unicité dynamique ($uKey).',
            ));
          }
          filledSlots.add(uKey);
        }

        if (!isInvariable && formsRaw.isNotEmpty) {
          var missingCount = 0;
          for (final slot in paradigm.expectedSlots(profile)) {
            final key = DeclensionForm.buildSlotKey(paradigm, slot);
            if (!filledSlots.contains(key)) {
              missingCount++;
            }
          }
          if (missingCount > 0) {
            warnings.add(ValidationIssue(
              entity: 'declension:$lemma#${pos.code}',
              message: '$missingCount case(s) manquante(s) sur ${paradigm.expectedSlots(profile).length} attendues.',
              isBlocking: false,
            ));
          }
        }
      }
    }

    // 3. Validate lessons + cycle graph
    final graph = <String, List<String>>{
      for (final e in existingPrerequisiteSlugsBySlug.entries) e.key: List.of(e.value),
    };

    for (final raw in rawLessons) {
      if (raw is! Map) {
        errors.add(const ValidationIssue(entity: 'lessons', message: 'Entrée non-objet.'));
        continue;
      }
      final map = Map<String, dynamic>.from(raw);
      final slug = (map['slug']?.toString() ?? '').trim();
      if (slug.isEmpty || !_asciiSlugRegex.hasMatch(slug)) {
        errors.add(ValidationIssue(
          entity: 'lesson:$slug',
          message: 'slug ASCII invalide ("$slug").',
        ));
        continue;
      }

      final level = (map['level']?.toString() ?? '').trim().toUpperCase();
      if (!_validLevels.contains(level)) {
        errors.add(ValidationIssue(
          entity: 'lesson:$slug',
          message: 'Niveau CECRL invalide ("$level").',
        ));
      }

      // Target tenses
      for (final tRaw in (map['target_tenses'] as List? ?? const [])) {
        if (tRaw is Map) {
          final mood = tRaw['mood']?.toString() ?? '';
          final tense = tRaw['tense']?.toString() ?? '';
          if (profile.findVerbParadigm(mood, tense) == null) {
            errors.add(ValidationIssue(
              entity: 'lesson:$slug',
              message: 'target_tenses ($mood, $tense) inconnu dans paradigms.',
            ));
          }
        }
      }

      // Target cases
      for (final cRaw in (map['target_cases'] as List? ?? const [])) {
        final caseCode = cRaw.toString();
        if (!profile.cases.contains(caseCode)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'target_cases "$caseCode" inconnu dans grammar_profile.cases.',
          ));
        }
      }

      // Linked declensions "<lemma>#<POS>"
      for (final refRaw in (map['linked_declensions'] as List? ?? const [])) {
        final refStr = TextNormalizer.normalize(refRaw.toString());
        if (!_linkedDeclensionRefRegex.hasMatch(refStr)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'Référence linked_declensions "$refStr" invalide (format attendu "<lemma>#<POS>").',
          ));
        }
      }

      // Blocks unique ASCII id
      final blockIds = <String>{};
      for (final bRaw in (map['blocks'] as List? ?? const [])) {
        if (bRaw is! Map) continue;
        final id = (bRaw['id']?.toString() ?? '').trim();
        if (id.isEmpty || !_asciiSlugRegex.hasMatch(id)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'id de bloc invalide ou non-ASCII ("$id").',
          ));
        } else if (!blockIds.add(id)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'id de bloc dupliqué ("$id").',
          ));
        }
      }

      // Exercises unique ASCII id + QCM answer not in distractors
      final exIds = <String>{};
      for (final eRaw in (map['exercises'] as List? ?? const [])) {
        if (eRaw is! Map) continue;
        final ex = LessonExercise.fromJson(Map<String, dynamic>.from(eRaw)).normalized();
        if (ex.id.isEmpty || !_asciiSlugRegex.hasMatch(ex.id)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'id d\'exercice invalide ou non-ASCII ("${ex.id}").',
          ));
        } else if (!exIds.add(ex.id)) {
          errors.add(ValidationIssue(
            entity: 'lesson:$slug',
            message: 'id d\'exercice dupliqué ("${ex.id}").',
          ));
        }

        if (ex.type == LessonExerciseType.qcm) {
          final normAns = TextNormalizer.normalizeForComparison(ex.answer);
          final normDistractors =
              ex.distractors.map(TextNormalizer.normalizeForComparison).toSet();
          if (normDistractors.contains(normAns)) {
            errors.add(ValidationIssue(
              entity: 'lesson:$slug:${ex.id}',
              message: 'QCM invalide : answer ("${ex.answer}") figure dans distractors.',
            ));
          }
        }
      }

      final prereqs = (map['prerequisites'] as List? ?? const [])
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (prereqs.contains(slug)) {
        errors.add(ValidationIssue(
          entity: 'lesson:$slug',
          message: 'Une leçon ne peut pas être son propre prérequis.',
        ));
      }
      graph[slug] = prereqs;
    }

    // Cycle detection across lesson graph
    if (_hasCycle(graph)) {
      errors.add(const ValidationIssue(
        entity: 'lessons',
        message: 'Cycle détecté dans le graphe des prerequisites.',
      ));
    }

    return BundleValidationResult(errors: errors, warnings: warnings);
  }

  static String? _validateVerbFormDimensions(
    ConjugationForm form,
    VerbParadigm paradigm,
  ) {
    if (paradigm.slots != null && paradigm.slots!.isNotEmpty) {
      final matchesSlot = paradigm.slots!.any((slot) => _slotMatches(slot, form.dimensions));
      if (!matchesSlot) {
        return 'Dimensions ${form.dimensions} hors slots autorisés pour (${form.mood}, ${form.tense}).';
      }
      return null;
    }

    for (final dim in paradigm.dimensions) {
      if (!form.dimensions.containsKey(dim) || form.dimensions[dim] == null) {
        return 'Dimension requise "$dim" manquante pour (${form.mood}, ${form.tense}).';
      }
    }
    return null;
  }

  static String? _validateDeclensionFormDimensions(
    DeclensionForm form,
    DeclensionParadigm paradigm,
    GrammarProfile profile,
  ) {
    final caseCode = form.caseCode;
    if (caseCode != null && !profile.cases.contains(caseCode)) {
      return 'Cas "$caseCode" absent de grammar_profile.cases.';
    }

    if (paradigm.slots != null && paradigm.slots!.isNotEmpty) {
      final matchesSlot = paradigm.slots!.any((slot) => _slotMatches(slot, form.dimensions));
      if (!matchesSlot) {
        return 'Dimensions ${form.dimensions} hors slots autorisés pour ${paradigm.pos}.';
      }
      return null;
    }

    for (final dim in paradigm.dimensions) {
      if (!form.dimensions.containsKey(dim) || form.dimensions[dim] == null) {
        return 'Dimension requise "$dim" manquante pour ${paradigm.pos}.';
      }
    }
    return null;
  }

  static bool _slotMatches(
    Map<String, dynamic> slot,
    Map<String, dynamic> dims,
  ) {
    for (final entry in slot.entries) {
      if (dims[entry.key] != entry.value) return false;
    }
    for (final entry in dims.entries) {
      if (!slot.containsKey(entry.key) && entry.value != null) return false;
    }
    return true;
  }

  static bool _hasCycle(Map<String, List<String>> graph) {
    final state = <String, int>{}; // 0: unvisited, 1: visiting, 2: visited
    bool dfs(String node) {
      final s = state[node] ?? 0;
      if (s == 1) return true;
      if (s == 2) return false;
      state[node] = 1;
      for (final next in graph[node] ?? const <String>[]) {
        if (dfs(next)) return true;
      }
      state[node] = 2;
      return false;
    }

    for (final node in graph.keys) {
      if ((state[node] ?? 0) == 0 && dfs(node)) return true;
    }
    return false;
  }
}
