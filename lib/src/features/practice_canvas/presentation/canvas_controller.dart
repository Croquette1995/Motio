import 'package:flutter/material.dart';
import 'tracing_painter.dart';

class CanvasState {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  final bool showWatermark;
  final bool isRevealed;

  const CanvasState({
    this.strokes = const [],
    this.currentStroke,
    this.showWatermark = false,
    this.isRevealed = false,
  });

  CanvasState copyWith({
    List<DrawingStroke>? strokes,
    DrawingStroke? currentStroke,
    bool clearCurrentStroke = false,
    bool? showWatermark,
    bool? isRevealed,
  }) {
    return CanvasState(
      strokes: strokes ?? this.strokes,
      currentStroke: clearCurrentStroke ? null : (currentStroke ?? this.currentStroke),
      showWatermark: showWatermark ?? this.showWatermark,
      isRevealed: isRevealed ?? this.isRevealed,
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
      points: [StrokePoint(position)],
      color: strokeColor,
      strokeWidth: strokeWidth,
    );
    _state = _state.copyWith(currentStroke: stroke);
    notifyListeners();
  }

  void onPanUpdate(Offset position) {
    if (_state.currentStroke == null) return;
    final updatedPoints = List<StrokePoint>.from(_state.currentStroke!.points)
      ..add(StrokePoint(position));
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
}
