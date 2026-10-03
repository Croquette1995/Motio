import 'package:flutter/material.dart';

class StrokePoint {
  final Offset offset;
  final double pressure;
  final int timestamp;

  const StrokePoint(this.offset, [this.pressure = 1.0, int? timestamp])
      : timestamp = timestamp ?? 0;
}

class DrawingStroke {
  final List<StrokePoint> points;
  final Color color;
  final double strokeWidth;

  DrawingStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 4.0,
  });
}

class TracingPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  final DrawingStroke? currentStroke;
  final String? watermarkWord;
  final bool showWatermark;
  final bool showRuledLines;
  final Color watermarkColor;
  final Color lineColor;

  TracingPainter({
    required this.strokes,
    this.currentStroke,
    this.watermarkWord,
    this.showWatermark = false,
    this.showRuledLines = true,
    this.watermarkColor = const Color(0x33000000),
    this.lineColor = const Color(0x1F000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw notebook ruled lines (baseline, midline, ascender line)
    if (showRuledLines) {
      _drawRuledLines(canvas, size);
    }

    // 2. Draw watermark guide word if enabled
    if (showWatermark && watermarkWord != null && watermarkWord!.isNotEmpty) {
      _drawWatermark(canvas, size);
    }

    // 3. Draw committed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    // 4. Draw currently active stroke
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!);
    }
  }

  void _drawRuledLines(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final ascenderY = centerY - 50;
    final baselineY = centerY + 50;

    // Top ascender line
    canvas.drawLine(Offset(20, ascenderY), Offset(size.width - 20, ascenderY), linePaint);
    // Baseline
    canvas.drawLine(Offset(20, baselineY), Offset(size.width - 20, baselineY), linePaint);

    // Dashed midline
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 20.0;
    final endX = size.width - 20;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, centerY),
        Offset((startX + dashWidth).clamp(0.0, endX), centerY),
        dashedPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  void _drawWatermark(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: watermarkWord,
      style: TextStyle(
        fontSize: 52,
        fontWeight: FontWeight.w400,
        letterSpacing: 4.0,
        fontFamily: 'monospace',
        color: watermarkColor,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 40);

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  void _drawStroke(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = stroke.color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.strokeWidth;

    if (stroke.points.length == 1) {
      canvas.drawCircle(
        stroke.points.first.offset,
        stroke.strokeWidth / 2,
        Paint()..color = stroke.color,
      );
      return;
    }

    final path = Path();
    path.moveTo(stroke.points[0].offset.dx, stroke.points[0].offset.dy);

    for (int i = 1; i < stroke.points.length; i++) {
      final p0 = stroke.points[i - 1].offset;
      final p1 = stroke.points[i].offset;

      // Quadratic bezier curve interpolation for smooth strokes
      final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
    }

    // Connect final point
    final lastPoint = stroke.points.last.offset;
    path.lineTo(lastPoint.dx, lastPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TracingPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.showWatermark != showWatermark ||
        oldDelegate.watermarkWord != watermarkWord;
  }
}
