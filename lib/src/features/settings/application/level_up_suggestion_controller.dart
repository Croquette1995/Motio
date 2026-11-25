import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../vocabulary/application/category_progress_service.dart';
import '../domain/cefr_level.dart';
import 'level_unlock_controller.dart';
import 'user_level_controller.dart';

/// Suggestion de montée en niveau : les critères de maîtrise du niveau actif
/// (Issue 21) sont atteints et un niveau suivant existe.
class LevelUpSuggestion {
  final CefrLevel currentLevel;
  final int totalWords;
  final int masteredWords;
  final int requiredWords;

  const LevelUpSuggestion({
    required this.currentLevel,
    required this.totalWords,
    required this.masteredWords,
    required this.requiredWords,
  });

  CefrLevel get targetLevel => CefrLevel.values[currentLevel.index + 1];

  String message() {
    final percent =
        totalWords == 0 ? 0 : ((masteredWords / totalWords) * 100).round();
    return 'Bravo, tu maîtrises $percent % du niveau ${currentLevel.code} '
        '→ passer au ${targetLevel.code} ?';
  }
}

class LevelUpSuggestionService {
  static const String coveredPrefsKey = 'covered_cefr_levels';
  static const String declinedPrefsKey = 'declined_level_up_targets';

  /// Retourne la suggestion si le corpus du niveau actif est maîtrisé à
  /// [LevelUnlockService.requiredMasteryRate], sinon null.
  static LevelUpSuggestion? evaluate({
    required CefrLevel userLevel,
    required int masteredWords,
    required int totalWords,
  }) {
    if (userLevel.index >= CefrLevel.values.length - 1) return null;
    if (totalWords <= 0) return null;
    final requiredWords =
        (LevelUnlockService.requiredMasteryRate * totalWords).ceil();
    if (masteredWords < requiredWords) return null;
    return LevelUpSuggestion(
      currentLevel: userLevel,
      totalWords: totalWords,
      masteredWords: masteredWords,
      requiredWords: requiredWords,
    );
  }

  /// Historique des niveaux couverts : trace persistée + tous les niveaux
  /// inférieurs au niveau actif, consultables en mode « révision ».
  static Set<CefrLevel> levelsCoveredBy(
    CefrLevel userLevel,
    Set<CefrLevel> persisted,
  ) =>
      {
        ...persisted,
        for (final level in CefrLevel.values)
          if (level.index < userLevel.index) level,
      };
}

class LevelUpSuggestionState {
  final LevelUpSuggestion? suggestion;
  final Set<CefrLevel> coveredLevels;
  final Set<CefrLevel> declinedTargets;

  const LevelUpSuggestionState({
    this.suggestion,
    this.coveredLevels = const {},
    this.declinedTargets = const {},
  });

  bool get isBannerVisible =>
      suggestion != null && !declinedTargets.contains(suggestion!.targetLevel);
}

class LevelUpSuggestionNotifier
    extends AsyncNotifier<LevelUpSuggestionState> {
  @override
  Future<LevelUpSuggestionState> build() async {
    final userLevel = ref.watch(userLevelProvider);
    final progress =
        await ref.watch(levelCategoryProgressProvider(userLevel).future);
    final suggestion = LevelUpSuggestionService.evaluate(
      userLevel: userLevel,
      masteredWords: progress.totalMastered,
      totalWords: progress.totalWords,
    );
    return LevelUpSuggestionState(
      suggestion: suggestion,
      coveredLevels: LevelUpSuggestionService.levelsCoveredBy(
        userLevel,
        await _readPrefs(LevelUpSuggestionService.coveredPrefsKey),
      ),
      declinedTargets:
          await _readPrefs(LevelUpSuggestionService.declinedPrefsKey),
    );
  }

  /// Accepter : trace du niveau couvert, déblocage persisté du niveau
  /// suivant, puis changement de niveau. Les niveaux précédents restent
  /// consultables (mode révision).
  Future<void> accept() async {
    final suggestion = state.valueOrNull?.suggestion;
    if (suggestion == null) return;
    final target = suggestion.targetLevel;
    final covered = {
      ...?state.valueOrNull?.coveredLevels,
      suggestion.currentLevel,
    };
    final declined = {...?state.valueOrNull?.declinedTargets}..remove(target);

    await _persistPrefs(LevelUpSuggestionService.coveredPrefsKey, covered);
    await _persistPrefs(LevelUpSuggestionService.declinedPrefsKey, declined);
    await _persistUnlock(target);
    await ref.read(userLevelProvider.notifier).setLevel(target);
  }

  /// Refuser : la bannière du dashboard se replie (persisté) mais peut être
  /// rouverte manuellement depuis les Paramètres.
  Future<void> decline() async {
    final suggestion = state.valueOrNull?.suggestion;
    if (suggestion == null) return;
    final target = suggestion.targetLevel;
    final declined = {...?state.valueOrNull?.declinedTargets, target};
    await _persistPrefs(LevelUpSuggestionService.declinedPrefsKey, declined);
    final current = state.valueOrNull;
    state = AsyncData(LevelUpSuggestionState(
      suggestion: current?.suggestion,
      coveredLevels: current?.coveredLevels ?? const {},
      declinedTargets: declined,
    ));
  }

  Future<void> _persistUnlock(CefrLevel target) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final codes = prefs.getStringList(LevelUnlockService.prefsKey) ?? const [];
      if (codes.contains(target.code)) return;
      await prefs.setStringList(
        LevelUnlockService.prefsKey,
        [...codes, target.code]..sort(),
      );
    } catch (_) {
      // Tests sans mock SharedPreferences : le déblocage reste implicite
      // (le niveau actif est toujours déverrouillé).
    }
  }

  Future<Set<CefrLevel>> _readPrefs(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final codes = prefs.getStringList(key) ?? const [];
      return codes.map((c) => CefrLevel.fromCode(c)).toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> _persistPrefs(String key, Set<CefrLevel> levels) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        key,
        levels.map((l) => l.code).toList()..sort(),
      );
    } catch (_) {
      // Tests sans mock SharedPreferences : l'état reste uniquement applicatif.
    }
  }
}

final levelUpSuggestionStateProvider =
    AsyncNotifierProvider<LevelUpSuggestionNotifier, LevelUpSuggestionState>(
  LevelUpSuggestionNotifier.new,
);

/// Vue synchrone pour les widgets : état vide pendant le chargement.
final levelUpSuggestionDisplayProvider =
    Provider<LevelUpSuggestionState>((ref) {
  return ref.watch(levelUpSuggestionStateProvider).valueOrNull ??
      const LevelUpSuggestionState();
});
