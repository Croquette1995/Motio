import 'dart:async';
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
  Timer? _autoAdvanceTimer;
  bool _hasValidated = false;

  @override
  void initState() {
    super.initState();
    _controller = CanvasController();
    _controller.addListener(_handleStateChange);
  }

  void _handleStateChange() {
    final state = _controller.state;
    if (state.isMatch == true && !_hasValidated) {
      _hasValidated = true;
      debugPrint('[CanvasPracticeView] isMatch is true for "${widget.word.term}". Revealing card and auto-advancing in 1200ms...');
      _controller.revealAnswer();
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer = Timer(const Duration(milliseconds: 1200), () {
        if (mounted) {
          debugPrint('[CanvasPracticeView] Auto-advancing via onSelfEvaluation(true)...');
          widget.onSelfEvaluation?.call(true);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant CanvasPracticeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _autoAdvanceTimer?.cancel();
      _hasValidated = false;
      _controller.resetForNewCard();
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _controller.removeListener(_handleStateChange);
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: b.pastelYellow.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: b.slate),
                      ),
                      const SizedBox(width: 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: state.isMatch! ? b.pastelMint : b.pastelRed.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: b.slate,
                        offset: const Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        state.isMatch! ? Icons.check_circle : Icons.cancel,
                        color: b.slate,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.isMatch!
                                  ? 'Reconnu : "${state.recognizedText}" ✓ Mot validé !'
                                  : 'Reconnu : "${(state.recognizedText ?? '').isEmpty ? 'Non reconnu' : state.recognizedText}" ✗',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: b.slate,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              state.isMatch!
                                  ? 'Passage automatique à la suite...'
                                  : 'Attendu : "${widget.word.term}". Effacez pour réessayer ou cliquez sur RÉVÉLER.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: b.slate.withValues(alpha: 0.85),
                              ),
                            ),
                            if (!state.isMatch! && state.candidates.length > 1) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Candidats ML Kit : [${state.candidates.take(3).join(', ')}]',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontStyle: FontStyle.italic,
                                  color: b.slate.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (state.isMatch!)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: b.slate,
                              foregroundColor: b.cardSurface,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              _autoAdvanceTimer?.cancel();
                              widget.onSelfEvaluation?.call(true);
                            },
                            child: const Text(
                              'CONTINUER',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
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
                        onPressed: () {
                          _autoAdvanceTimer?.cancel();
                          _hasValidated = false;
                          _controller.clearCanvas();
                        },
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
                          onPressed: (state.strokes.isEmpty || state.isRecognizing)
                              ? null
                              : () {
                                  debugPrint('[CanvasPracticeView] User tapped VÉRIFIER for "${widget.word.term}"');
                                  _controller.recognizeHandwriting(
                                    inkService,
                                    widget.word.term,
                                    languageCode: 'en',
                                  );
                                },
                          icon: state.isRecognizing
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: b.slate,
                                  ),
                                )
                              : const Icon(Icons.draw, size: 18),
                          label: Text(state.isRecognizing ? 'ANALYSE...' : 'VÉRIFIER'),
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
