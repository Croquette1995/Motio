import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/cefr_level.dart';

class UserLevelNotifier extends Notifier<CefrLevel> {
  static const userLevelKey = 'user_cefr_level';
  static const levelOnboardedKey = 'user_level_onboarded';

  @override
  CefrLevel build() {
    _load();
    return CefrLevel.a1;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(userLevelKey);
    if (savedCode != null) {
      state = CefrLevel.fromCode(savedCode);
    }
  }

  Future<void> setLevel(CefrLevel level) async {
    state = level;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userLevelKey, level.code);
    await prefs.setBool(levelOnboardedKey, true);
  }

  /// Re-choix de la langue/depuis l'onboarding sans toucher à la progression.
  Future<void> restartOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(levelOnboardedKey, false);
    ref.invalidate(isLevelOnboardedProvider);
  }

  /// Retour au niveau de départ A1 et à l'état non-onboardé.
  Future<void> reset() async {
    state = CefrLevel.a1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userLevelKey);
    await prefs.setBool(levelOnboardedKey, false);
    ref.invalidate(isLevelOnboardedProvider);
  }
}

final userLevelProvider =
    NotifierProvider<UserLevelNotifier, CefrLevel>(UserLevelNotifier.new);

final isLevelOnboardedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(UserLevelNotifier.levelOnboardedKey) ?? false;
});
