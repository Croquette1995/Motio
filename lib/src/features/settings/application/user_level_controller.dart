import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/cefr_level.dart';

class UserLevelNotifier extends Notifier<CefrLevel> {
  static const _kUserLevelKey = 'user_cefr_level';
  static const _kLevelOnboardedKey = 'user_level_onboarded';

  @override
  CefrLevel build() {
    _load();
    return CefrLevel.a1;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_kUserLevelKey);
    if (savedCode != null) {
      state = CefrLevel.fromCode(savedCode);
    }
  }

  Future<void> setLevel(CefrLevel level) async {
    state = level;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserLevelKey, level.code);
    await prefs.setBool(_kLevelOnboardedKey, true);
  }
}

final userLevelProvider =
    NotifierProvider<UserLevelNotifier, CefrLevel>(UserLevelNotifier.new);

final isLevelOnboardedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(UserLevelNotifier._kLevelOnboardedKey) ?? false;
});
