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
    test('normalizeWord correctly lowercases, strips accents, punctuation and whitespace', () {
      expect(DigitalInkRecognitionService.normalizeWord('  DEADLINE  '), equals('deadline'));
      expect(DigitalInkRecognitionService.normalizeWord('deadline.'), equals('deadline'));
      expect(DigitalInkRecognitionService.normalizeWord('«deadline»'), equals('deadline'));
      expect(DigitalInkRecognitionService.normalizeWord('résumé'), equals('resume'));
      expect(DigitalInkRecognitionService.normalizeWord('façade'), equals('facade'));
      expect(DigitalInkRecognitionService.normalizeWord('take   off'), equals('take off'));
      expect(DigitalInkRecognitionService.normalizeWord('well-being', removePunctuation: true), equals('wellbeing'));
    });

    test('isWordMatch performs tolerant normalization matching', () {
      final candidates = [
        mlkit.RecognitionCandidate(text: '  Hello. ', score: 0.9),
        mlkit.RecognitionCandidate(text: 'WORLD', score: 0.5),
      ];

      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'hello'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'HELLO'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'world'), isTrue);
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'other'), isFalse);
    });

    test('matchWord finds match on non-first candidate and returns WordMatchResult', () {
      final candidates = [
        mlkit.RecognitionCandidate(text: '.', score: 2190.51),
        mlkit.RecognitionCandidate(text: 'deadline', score: 562.73),
      ];

      final result = DigitalInkRecognitionService.matchWord(candidates, 'deadline');
      expect(result.isMatch, isTrue);
      expect(result.matchedText, equals('deadline'));
      expect(result.matchedCandidate?.score, equals(562.73));
      expect(result.cleanTarget, equals('deadline'));
    });

    test('matchWord handles space-tolerant and punctuation differences', () {
      final candidates = [
        mlkit.RecognitionCandidate(text: 'dead line', score: 100),
      ];
      expect(DigitalInkRecognitionService.isWordMatch(candidates, 'deadline'), isTrue);

      final candidatesPunct = [
        mlkit.RecognitionCandidate(text: 'well-being', score: 100),
      ];
      expect(DigitalInkRecognitionService.isWordMatch(candidatesPunct, 'wellbeing'), isTrue);
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
      expect(ink.strokes.first.points.first.t, equals(10));
    });

    test('convertStrokesToInk preserves explicit timestamp when provided', () {
      final strokes = [
        DrawingStroke(
          points: [
            const StrokePoint(Offset(10, 20), 1.0, 1000),
            const StrokePoint(Offset(15, 25), 1.0, 1050),
          ],
          color: Colors.black,
        ),
      ];

      final ink = controller.convertStrokesToInk(strokes);
      expect(ink.strokes.first.points[0].t, equals(1000));
      expect(ink.strokes.first.points[1].t, equals(1050));
    });

    test('onPanStart and onPanUpdate assign positive timestamps', () {
      controller.onPanStart(const Offset(5, 5));
      controller.onPanUpdate(const Offset(10, 10));
      final stroke = controller.state.currentStroke;
      expect(stroke, isNotNull);
      expect(stroke!.points.length, equals(2));
      expect(stroke.points[0].timestamp, greaterThan(0));
      expect(stroke.points[1].timestamp, greaterThanOrEqualTo(stroke.points[0].timestamp));
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
