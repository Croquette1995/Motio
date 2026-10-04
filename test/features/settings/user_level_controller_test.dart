import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserLevelController Tests', () {
    test('Default user level is A1', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final level = container.read(userLevelProvider);
      expect(level, equals(CefrLevel.a1));
    });

    test('setLevel updates level and persists to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(userLevelProvider.notifier).setLevel(CefrLevel.b2);

      final updatedLevel = container.read(userLevelProvider);
      expect(updatedLevel, equals(CefrLevel.b2));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_cefr_level'), equals('B2'));
      expect(prefs.getBool('user_level_onboarded'), isTrue);
    });

    test('CefrLevel fromCode handles case-insensitivity and fallback', () {
      expect(CefrLevel.fromCode('b1'), equals(CefrLevel.b1));
      expect(CefrLevel.fromCode('B2'), equals(CefrLevel.b2));
      expect(CefrLevel.fromCode('UNKNOWN'), equals(CefrLevel.a1));
    });
  });
}
