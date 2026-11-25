import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../vocabulary/application/category_progress_service.dart';
import '../domain/cefr_level.dart';
import 'user_level_controller.dart';

/// État de verrouillage des niveaux CECRL pour l'utilisateur courant.
class LevelUnlockState {
  final CefrLevel userLevel;
  final Set<CefrLevel> unlockedLevels;
  final Map<CefrLevel, UnlockRequirement> requirements;

  const LevelUnlockState({
    required this.userLevel,
    required this.unlockedLevels,
    required this.requirements,
  });

  bool isUnlocked(CefrLevel level) =>
      level.index <= userLevel.index || unlockedLevels.contains(level);

  bool isReviewLevel(CefrLevel level) => level.index < userLevel.index;

  UnlockRequirement? requirementFor(CefrLevel level) =>
      level.index > userLevel.index ? requirements[level] : null;
}

/// Statut SRS « Maîtrisé » rapporté au corpus du niveau prérequis.
class UnlockRequirement {
  final CefrLevel prerequisite;
  final int masteredWords;
  final int requiredWords;

  const UnlockRequirement({
    required this.prerequisite,
    required this.masteredWords,
    required this.requiredWords,
  });

  double get progress =>
      requiredWords == 0 ? 0.0 : (masteredWords / requiredWords).clamp(0.0, 1.0);

  bool get isMet => masteredWords >= requiredWords;

  String message({required CefrLevel target}) {
    final percent = (LevelUnlockService.requiredMasteryRate * 100).round();
    return 'Maîtrisez $percent % du corpus ${prerequisite.code} '
        '($masteredWords/$requiredWords mots) pour débloquer le ${target.code}.';
  }
}

class LevelUnlockService {
  static const double requiredMasteryRate = 0.7;
  static const String prefsKey = 'unlocked_cefr_levels';

  static bool isUnlocked({
    required CefrLevel level,
    required CefrLevel userLevel,
    required Set<CefrLevel> unlockedLevels,
  }) =>
      level.index <= userLevel.index || unlockedLevels.contains(level);

  static CefrLevel prerequisiteFor(CefrLevel level) =>
      CefrLevel.values[level.index - 1];

  static UnlockRequirement? requirementFor(
    CefrLevel level,
    Map<CefrLevel, LevelProgressData> progressByLevel,
  ) {
    if (level.index == 0) return null;
    final prerequisite = prerequisiteFor(level);
    final data = progressByLevel[prerequisite];
    if (data == null) return null;
    return UnlockRequirement(
      prerequisite: prerequisite,
      masteredWords: data.totalMastered,
      requiredWords: (requiredMasteryRate * data.totalWords).ceil(),
    );
  }
}

class LevelUnlockNotifier extends AsyncNotifier<LevelUnlockState> {
  @override
  Future<LevelUnlockState> build() async {
    final userLevel = ref.watch(userLevelProvider);

    final progressByLevel = <CefrLevel, LevelProgressData>{};
    for (final level in CefrLevel.values) {
      progressByLevel[level] =
          await ref.watch(levelCategoryProgressProvider(level).future);
    }

    var persisted = await _readPersistedUnlocks();

    final requirements = <CefrLevel, UnlockRequirement>{};
    final criterionUnlocked = <CefrLevel>{};
    for (final level in CefrLevel.values.where((l) => l.index > userLevel.index)) {
      final req = LevelUnlockService.requirementFor(level, progressByLevel);
      if (req == null) continue;
      requirements[level] = req;
      if (req.isMet) criterionUnlocked.add(level);
    }

    // Persister les déblocages obtenus par critère : ils ne sont jamais re-évalués.
    final missing = criterionUnlocked.difference(persisted);
    if (missing.isNotEmpty) {
      persisted = {...persisted, ...missing};
      await _persistUnlocks(persisted);
    }

    return LevelUnlockState(
      userLevel: userLevel,
      unlockedLevels: {...persisted, ...criterionUnlocked},
      requirements: requirements,
    );
  }

  Future<void> unlockManually(CefrLevel level) async {
    final current = state.valueOrNull;
    final unlockedLevels = {...?current?.unlockedLevels, level};
    await _persistUnlocks(unlockedLevels);
    state = AsyncData(
      LevelUnlockState(
        userLevel: ref.read(userLevelProvider),
        unlockedLevels: unlockedLevels,
        requirements: current?.requirements ?? const {},
      ),
    );
  }

  Future<Set<CefrLevel>> _readPersistedUnlocks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final codes = prefs.getStringList(LevelUnlockService.prefsKey) ?? const [];
      return codes.map((c) => CefrLevel.fromCode(c)).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _persistUnlocks(Set<CefrLevel> levels) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final codes =
          levels.map((l) => l.code).toList()..sort();
      await prefs.setStringList(LevelUnlockService.prefsKey, codes);
    } catch (_) {
      // Tests sans mock SharedPreferences : l'état reste uniquement applicatif.
    }
  }
}

final levelUnlockStateProvider =
    AsyncNotifierProvider<LevelUnlockNotifier, LevelUnlockState>(
  LevelUnlockNotifier.new,
);

/// Vue synchrone pour les widgets : fallback verrouillé pendant le chargement.
final levelUnlockDisplayProvider = Provider<LevelUnlockState>((ref) {
  final asyncValue = ref.watch(levelUnlockStateProvider);
  final userLevel = ref.watch(userLevelProvider);
  return asyncValue.valueOrNull ??
      LevelUnlockState(
        userLevel: userLevel,
        unlockedLevels: const {},
        requirements: const {},
      );
});
