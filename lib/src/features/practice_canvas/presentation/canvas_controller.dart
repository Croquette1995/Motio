import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;
import '../services/digital_ink_service.dart';
import 'tracing_painter.dart';

class CanvasState {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  final bool showWatermark;
  final bool isRevealed;
  final bool isRecognizing;
  final bool? isMatch;
  final String? recognizedText;
  final List<String> candidates;

  const CanvasState({
    this.strokes = const [],
    this.currentStroke,
    this.showWatermark = false,
    this.isRevealed = false,
    this.isRecognizing = false,
    this.isMatch,
    this.recognizedText,
    this.candidates = const [],
  });

  CanvasState copyWith({
    List<DrawingStroke>? strokes,
    DrawingStroke? currentStroke,
    bool clearCurrentStroke = false,
    bool? showWatermark,
    bool? isRevealed,
    bool? isRecognizing,
    bool? isMatch,
    bool resetRecognition = false,
    String? recognizedText,
    List<String>? candidates,
  }) {
    return CanvasState(
      strokes: strokes ?? this.strokes,
      currentStroke: clearCurrentStroke ? null : (currentStroke ?? this.currentStroke),
      showWatermark: showWatermark ?? this.showWatermark,
      isRevealed: isRevealed ?? this.isRevealed,
      isRecognizing: isRecognizing ?? this.isRecognizing,
      isMatch: resetRecognition ? null : (isMatch ?? this.isMatch),
      recognizedText: resetRecognition ? null : (recognizedText ?? this.recognizedText),
      candidates: resetRecognition ? const [] : (candidates ?? this.candidates),
    );
  }
}

class CanvasController extends ChangeNotifier {
  CanvasState _state = const CanvasState();
  Color strokeColor = const Color(0xFF1E293B);
  double strokeWidth = 4.0;

  CanvasState get state => _state;

  void onPanStart(Offset position) {
    final stroke = DrawingStroke(
      points: [
        StrokePoint(
          position,
          1.0,
          DateTime.now().millisecondsSinceEpoch,
        ),
      ],
      color: strokeColor,
      strokeWidth: strokeWidth,
    );
    _state = _state.copyWith(currentStroke: stroke);
    notifyListeners();
  }

  void onPanUpdate(Offset position) {
    if (_state.currentStroke == null) return;
    final updatedPoints = List<StrokePoint>.from(_state.currentStroke!.points)
      ..add(
        StrokePoint(
          position,
          1.0,
          DateTime.now().millisecondsSinceEpoch,
        ),
      );
    final updatedStroke = DrawingStroke(
      points: updatedPoints,
      color: _state.currentStroke!.color,
      strokeWidth: _state.currentStroke!.strokeWidth,
    );
    _state = _state.copyWith(currentStroke: updatedStroke);
    notifyListeners();
  }

  void onPanEnd() {
    if (_state.currentStroke == null) return;
    final updatedStrokes = List<DrawingStroke>.from(_state.strokes)..add(_state.currentStroke!);
    _state = _state.copyWith(
      strokes: updatedStrokes,
      clearCurrentStroke: true,
    );
    notifyListeners();
  }

  void clearCanvas() {
    _state = _state.copyWith(
      strokes: const [],
      clearCurrentStroke: true,
      resetRecognition: true,
    );
    notifyListeners();
  }

  void toggleWatermark() {
    _state = _state.copyWith(showWatermark: !_state.showWatermark);
    notifyListeners();
  }

  void revealAnswer() {
    _state = _state.copyWith(isRevealed: true);
    notifyListeners();
  }

  void resetForNewCard() {
    _state = const CanvasState();
    notifyListeners();
  }

  /// Converts internal [DrawingStroke] list to ML Kit [mlkit.Ink]
  mlkit.Ink convertStrokesToInk(List<DrawingStroke> strokes) {
    int fallbackTime = 0;
    final ink = mlkit.Ink();

    for (final stroke in strokes) {
      final inkStroke = mlkit.Stroke();
      for (final pt in stroke.points) {
        final t = pt.timestamp > 0 ? pt.timestamp : (fallbackTime += 10);
        inkStroke.points.add(
          mlkit.StrokePoint(
            x: pt.offset.dx,
            y: pt.offset.dy,
            t: t,
          ),
        );
      }
      ink.strokes.add(inkStroke);
      fallbackTime += 100;
    }

    return ink;
  }

  /// Recognizes handwriting drawn on canvas against [targetWord]
  Future<void> recognizeHandwriting(
    DigitalInkRecognitionService service,
    String targetWord, {
    String languageCode = 'en',
  }) async {
    if (_state.strokes.isEmpty) {
      debugPrint('[CanvasController] recognizeHandwriting: strokes is empty, ignoring call.');
      return;
    }

    final totalPoints = _state.strokes.fold<int>(0, (sum, s) => sum + s.points.length);
    debugPrint('[CanvasController] recognizeHandwriting started for target: "$targetWord", strokes: ${_state.strokes.length}, totalPoints: $totalPoints, lang: $languageCode');

    _state = _state.copyWith(isRecognizing: true);
    notifyListeners();

    try {
      final ink = convertStrokesToInk(_state.strokes);
      final results = await service.recognizeInk(ink, languageCode: languageCode);
      debugPrint('[CanvasController] Recognition returned ${results.length} candidate(s)');

      final matchResult = DigitalInkRecognitionService.matchWord(results, targetWord);
      final topCandidate = results.isNotEmpty ? results.first.text.trim() : '';
      final displayText = matchResult.isMatch
          ? (matchResult.matchedText ?? topCandidate)
          : topCandidate;

      debugPrint('[CanvasController] matchResult: isMatch=${matchResult.isMatch}, displayText="$displayText", candidates=${matchResult.allCandidates}');

      _state = _state.copyWith(
        isRecognizing: false,
        isMatch: matchResult.isMatch,
        recognizedText: displayText,
        candidates: matchResult.allCandidates,
      );
    } catch (e, st) {
      debugPrint('[CanvasController ERROR] recognizeHandwriting failed: $e\n$st');
      _state = _state.copyWith(
        isRecognizing: false,
        isMatch: false,
        recognizedText: null,
        candidates: const [],
      );
    } finally {
      notifyListeners();
    }
  }
}
