import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';

void main() {
  group('Barème CECRL — quotas de mots par niveau', () {
    test('les quotas non cumulés correspondent au barème documenté', () {
      expect(CefrLevel.a1.levelWordQuota, 500);
      expect(CefrLevel.a2.levelWordQuota, 700);
      expect(CefrLevel.b1.levelWordQuota, 1000);
      expect(CefrLevel.b2.levelWordQuota, 1300);
    });

    test('les volumes cumulés restent cohérents entre eux', () {
      expect(CefrLevel.a1.targetWordCount, 500);
      expect(CefrLevel.a2.targetWordCount, 1200);
      expect(CefrLevel.b1.targetWordCount, 2200);
      expect(CefrLevel.b2.targetWordCount, 3500);
    });

    test('le quota de chaque niveau est dérivé de l\'écart entre volumes cumulés', () {
      int previousCumulated = 0;
      for (final level in CefrLevel.values) {
        expect(level.levelWordQuota, level.targetWordCount - previousCumulated);
        previousCumulated = level.targetWordCount;
      }
    });
  });
}
