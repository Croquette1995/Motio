import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/domain/word.dart';
import 'canvas_controller.dart';
import 'digital_ink_providers.dart';
import 'tracing_painter.dart';

class CanvasPracticeView extends ConsumerStatefulWidget {
  final Word word;
  final ValueChanged<bool>? onSelfEvaluation;

  const CanvasPracticeView({
    super.key,
    required this.word,
    this.onSelfEvaluation,
  });

  @override
  ConsumerState<CanvasPracticeView> createState() => _CanvasPracticeViewState();
}

class _CanvasPracticeViewState extends ConsumerState<CanvasPracticeView> {
  late final CanvasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CanvasController();
  }

  @override
  void didUpdateWidget(covariant CanvasPracticeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _controller.resetForNewCard();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatMaskedSentence(String sentence, String term) {
    final pattern = RegExp(RegExp.escape(term), caseSensitive: false);
    return sentence.replaceAll(pattern, '_______');
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final inkService = ref.watch(digitalInkServiceProvider);
    _controller.strokeColor = b.slate;

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final state = _controller.state;
        final maskedSentence = _formatMaskedSentence(
          widget.word.contextSentence,
          widget.word.term,
        );

        return Column(
          children: [
            // Header card with prompts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: b.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: b.slate, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: b.slate,
                      offset: const Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: b.pastelBlue,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: b.slate, width: 1),
                          ),
                          child: Text(
                            widget.word.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: b.slate,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: b.pastelYellow,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: b.slate, width: 1),
                          ),
                          child: Text(
                            widget.word.level.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: b.slate,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.isRevealed ? widget.word.contextSentence : maskedSentence,
                      style: t.titleMedium?.copyWith(
                        fontSize: 17,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: b.slate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sens en français : ${widget.word.translation}',
                      style: t.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: b.slate.withValues(alpha: 0.75),
                      ),
                    ),
                    if (state.isRevealed) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: b.pastelMint,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: b.slate, width: 1.2),
                        ),
                        child: Text(
                          'MOT CIBLE : ${widget.word.term.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: b.slate,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Canvas drawing surface with Bauhaus crisp outline & offset shadow
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: b.cardSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: b.slate, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: b.slate,
                        offset: const Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onPanStart: (details) => _controller.onPanStart(details.localPosition),
                      onPanUpdate: (details) => _controller.onPanUpdate(details.localPosition),
                      onPanEnd: (_) => _controller.onPanEnd(),
                      child: CustomPaint(
                        painter: TracingPainter(
                          strokes: state.strokes,
                          currentStroke: state.currentStroke,
                          watermarkWord: widget.word.term,
                          showWatermark: state.showWatermark,
                          watermarkColor: b.slate.withValues(alpha: 0.15),
                          lineColor: b.lineGrey,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Recognition Result Feedback Banner
            if (state.isRecognizing) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: b.pastelYellow.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: b.slate),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Analyse de l\'écriture manuscrite ML Kit...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: b.slate,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (state.isMatch != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: state.isMatch! ? b.pastelMint : b.pastelRed.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.isMatch! ? Icons.check_circle : Icons.cancel,
                        color: b.slate,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.isMatch!
                              ? 'Reconnu : "${state.recognizedText}" ✓ Correspond au mot ciblé !'
                              : 'Reconnu : "${(state.recognizedText ?? '').isEmpty ? 'Non reconnu' : state.recognizedText}" ✗ (Attendu : ${widget.word.term})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: b.slate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Bottom toolbar and actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: b.slate, width: 1.2),
                          foregroundColor: b.slate,
                        ),
                        onPressed: _controller.clearCanvas,
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('EFFACER'),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: b.slate, width: 1.2),
                          foregroundColor: b.slate,
                        ),
                        onPressed: _controller.toggleWatermark,
                        icon: Icon(
                          state.showWatermark ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                        ),
                        label: Text(state.showWatermark ? 'MASQUER' : 'CALQUE'),
                      ),
                      if (inkService.isPlatformSupported)
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: b.pastelYellow,
                            side: BorderSide(color: b.slate, width: 1.2),
                            foregroundColor: b.slate,
                          ),
                          onPressed: state.strokes.isEmpty
                              ? null
                              : () => _controller.recognizeHandwriting(
                                    inkService,
                                    widget.word.term,
                                    languageCode: 'en',
                                  ),
                          icon: const Icon(Icons.draw, size: 18),
                          label: const Text('VÉRIFIER'),
                        ),
                      if (!state.isRevealed)
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: b.slate,
                            foregroundColor: b.cardSurface,
                            shape: bauhausBorder(radius: 8, color: b.slate),
                          ),
                          onPressed: _controller.revealAnswer,
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('RÉVÉLER'),
                        ),
                    ],
                  ),
                  if (state.isRevealed) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: b.pastelRed,
                              foregroundColor: b.slate,
                              side: BorderSide(color: b.slate, width: 1.5),
                              shape: bauhausBorder(radius: 8, color: b.slate),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => widget.onSelfEvaluation?.call(false),
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text(
                              'À REVOIR',
                              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: b.pastelMint,
                              foregroundColor: b.slate,
                              side: BorderSide(color: b.slate, width: 1.5),
                              shape: bauhausBorder(radius: 8, color: b.slate),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => widget.onSelfEvaluation?.call(true),
                            icon: const Icon(Icons.check, size: 20),
                            label: const Text(
                              'MÉMORISÉ',
                              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
