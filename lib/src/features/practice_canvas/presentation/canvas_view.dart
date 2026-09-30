import 'package:flutter/material.dart';
import '../../vocabulary/domain/word.dart';
import 'canvas_controller.dart';
import 'tracing_painter.dart';

class CanvasPracticeView extends StatefulWidget {
  final Word word;
  final ValueChanged<bool>? onSelfEvaluation;

  const CanvasPracticeView({
    super.key,
    required this.word,
    this.onSelfEvaluation,
  });

  @override
  State<CanvasPracticeView> createState() => _CanvasPracticeViewState();
}

class _CanvasPracticeViewState extends State<CanvasPracticeView> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _controller.strokeColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF);

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
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            label: Text(
                              widget.word.category,
                              style: const TextStyle(fontSize: 12),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.word.level,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.isRevealed ? widget.word.contextSentence : maskedSentence,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sens en français : ${widget.word.translation}',
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      if (state.isRevealed) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Mot cible : ${widget.word.term}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Canvas drawing surface
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
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
                          watermarkColor: isDark
                              ? const Color(0x33FFFFFF)
                              : const Color(0x2A000000),
                          lineColor: isDark
                              ? const Color(0x22FFFFFF)
                              : const Color(0x1F000000),
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom toolbar and actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _controller.clearCanvas,
                        icon: const Icon(Icons.clear),
                        label: const Text('Effacer'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _controller.toggleWatermark,
                        icon: Icon(
                          state.showWatermark ? Icons.visibility_off : Icons.visibility,
                        ),
                        label: Text(state.showWatermark ? 'Masquer calque' : 'Calque estompé'),
                      ),
                      if (!state.isRevealed)
                        FilledButton.icon(
                          onPressed: _controller.revealAnswer,
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Révéler'),
                        ),
                    ],
                  ),
                  if (state.isRevealed) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => widget.onSelfEvaluation?.call(false),
                            icon: const Icon(Icons.close),
                            label: const Text('Échec (À revoir)'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => widget.onSelfEvaluation?.call(true),
                            icon: const Icon(Icons.check),
                            label: const Text('Succès (Mémorisé)'),
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
