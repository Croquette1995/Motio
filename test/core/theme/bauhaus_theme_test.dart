import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/theme/app_theme.dart';

void main() {
  group('Bauhaus Theme Tests', () {
    testWidgets('AppTheme.lightTheme contains BauhausColors extension and correct tokens', (tester) async {
      final theme = AppTheme.lightTheme;
      final bauhaus = theme.extension<BauhausColors>();

      expect(bauhaus, isNotNull);
      expect(bauhaus!.chalk, const Color(0xFFF7F8FA));
      expect(bauhaus.cardSurface, const Color(0xFFFFFFFF));
      expect(bauhaus.slate, const Color(0xFF1E242B));
      expect(bauhaus.pastelBlue, const Color(0xFF7BA4D5));
      expect(bauhaus.pastelRed, const Color(0xFFE98877));
      expect(bauhaus.pastelYellow, const Color(0xFFF6CC70));
      expect(bauhaus.pastelMint, const Color(0xFF8DCBB5));
      expect(bauhaus.lineGrey, const Color(0xFFE2E5EA));

      expect(theme.scaffoldBackgroundColor, const Color(0xFFF7F8FA));
      expect(theme.splashFactory, NoSplash.splashFactory);
      expect(theme.highlightColor, Colors.transparent);
    });

    testWidgets('BauhausProgress renders geometric modular segments', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: BauhausProgress(done: 3, total: 8),
          ),
        ),
      );

      expect(find.byType(BauhausProgress), findsOneWidget);
      final row = tester.widget<Row>(find.descendant(
        of: find.byType(BauhausProgress),
        matching: find.byType(Row),
      ));
      expect(row.children.length, 8);
    });

    testWidgets('BauhausRule renders geometric punctuation marks', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: BauhausRule(),
          ),
        ),
      );

      expect(find.byType(BauhausRule), findsOneWidget);
    });
  });
}
