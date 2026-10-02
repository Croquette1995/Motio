import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;
import 'package:lexiflow/src/features/practice_canvas/presentation/canvas_controller.dart';
import 'package:lexiflow/src/features/practice_canvas/presentation/canvas_view.dart';
import 'package:lexiflow/src/features/practice_canvas/presentation/tracing_painter.dart';
import 'package:lexiflow/src/features/practice_canvas/services/digital_ink_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word.dart';

void main() {
  group('DigitalInkRecognitionService Unit Tests', () {
    test('isWordMatch performs case-insensitive and trimmed string matching', () {
      final candidates = [
        mlkit.RecognitionCandidate(text: '  Hello ', score: 0.9),
        mlkit.RecognitionCandidate(text: 'World', score: 0.5),
      ];

      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'hello'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'HELLO'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'world'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'other'), isFalse);
    });

    test('isWordMatch returns false for empty input or empty candidates', () {
      expect(DigitalInkRecognitionService.isWordMatch([], 'hello'), isFalse);
      expect(
        DigitalInkRecognitionService.isWordMatch([
          mlkit.RecognitionCandidate(text: 'hello', score: 1.0)
        ], '  '),
        isFalse,
      );
    });
  });

  group('CanvasController Unit Tests', () {
    late CanvasController controller;

    setUp(() {
      controller = CanvasController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('convertStrokesToInk builds ML Kit Ink correctly from DrawingStroke list', () {
      final strokes = [
        DrawingStroke(
          points: [
            const StrokePoint(Offset(10, 20)),
            const StrokePoint(Offset(15, 25)),
          ],
          color: Colors.black,
        ),
      ];

      final ink = controller.convertStrokesToInk(strokes);

      expect(ink.strokes.length, equals(1));
      expect(ink.strokes.first.points.length, equals(2));
      expect(ink.strokes.first.points.first.x, equals(10.0));
      expect(ink.strokes.first.points.first.y, equals(20.0));
    });

    test('clearCanvas resets strokes and recognition state', () {
      controller.onPanStart(const Offset(10, 10));
      controller.onPanEnd();
      expect(controller.state.strokes.isNotEmpty, isTrue);

      controller.clearCanvas();
      expect(controller.state.strokes.isEmpty, isTrue);
      expect(controller.state.isMatch, isNull);
      expect(controller.state.recognizedText, isNull);
    });
  });

  group('CanvasPracticeView Widget Test', () {
    final testWord = Word(
      id: 1,
      term: 'apple',
      translation: 'pomme',
      contextSentence: 'I ate a sweet apple.',
      category: 'food',
      level: 'b1',
      createdAt: DateTime.now(),
    );

    testWidgets('CanvasPracticeView renders header, canvas, and action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProviderScope(
              child: CanvasPracticeView(
                word: testWord,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('FOOD'), findsOneWidget);
      expect(find.text('B1'), findsOneWidget);
      expect(find.textContaining('Sens en français : pomme'), findsOneWidget);
      expect(find.text('EFFACER'), findsOneWidget);
      expect(find.text('CALQUE'), findsOneWidget);
      expect(find.text('RÉVÉLER'), findsOneWidget);
    });
  });
}
