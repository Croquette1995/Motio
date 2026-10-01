import 'package:flutter/material.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/domain/word.dart';

class ClozePracticeView extends StatefulWidget {
  final Word word;
  final List<Word> availableWords;
  final ValueChanged<bool>? onAnswerSubmitted;

  const ClozePracticeView({
    super.key,
    required this.word,
    this.availableWords = const [],
    this.onAnswerSubmitted,
  });

  @override
  State<ClozePracticeView> createState() => _ClozePracticeViewState();
}

class _ClozePracticeViewState extends State<ClozePracticeView> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnswered = false;
  bool _isCorrect = false;
  late List<String> _choiceOptions;

  @override
  void initState() {
    super.initState();
    _setupOptions();
  }

  @override
  void didUpdateWidget(covariant ClozePracticeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _textController.clear();
      _isAnswered = false;
      _isCorrect = false;
      _setupOptions();
    }
  }

  void _setupOptions() {
    final distractors = widget.availableWords
        .where((w) => w.id != widget.word.id)
        .map((w) => w.term)
        .toList()
      ..shuffle();

    _choiceOptions = [
      widget.word.term,
      ...distractors.take(3),
    ]..shuffle();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _validateSelection(String selected) {
    if (_isAnswered) return;

    final correct = selected.trim().toLowerCase() == widget.word.term.trim().toLowerCase();
    setState(() {
      _isAnswered = true;
      _isCorrect = correct;
    });

    widget.onAnswerSubmitted?.call(correct);
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    final pattern = RegExp(RegExp.escape(widget.word.term), caseSensitive: false);
    final sentenceWithBlank = widget.word.contextSentence.replaceAll(pattern, '__________');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                Text(
                  _isAnswered ? widget.word.contextSentence : sentenceWithBlank,
                  style: t.titleMedium?.copyWith(
                    fontSize: 18,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: b.slate,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Traduction : ${widget.word.translation}',
                  style: t.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: b.slate.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'CHOISISSEZ LE TERME EXACT :',
            style: t.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: b.slate.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          ..._choiceOptions.map((option) {
            Color tileBg = b.cardSurface;
            if (_isAnswered) {
              if (option.toLowerCase() == widget.word.term.toLowerCase()) {
                tileBg = b.pastelMint;
              } else {
                tileBg = b.chalk;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _isAnswered ? null : () => _validateSelection(option),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: tileBg,
                    borderRadius: BorderRadius.circular(10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: b.slate,
                        ),
                      ),
                      if (_isAnswered && option.toLowerCase() == widget.word.term.toLowerCase())
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: b.slate,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, size: 14, color: b.cardSurface),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_isAnswered) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isCorrect ? b.pastelMint : b.pastelYellow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: b.slate, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(
                    _isCorrect ? Icons.check_circle : Icons.info_outline,
                    color: b.slate,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isCorrect
                          ? 'Excellent ! Le mot est validé en contexte.'
                          : 'Rappel : "${widget.word.term}" = ${widget.word.translation}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: b.slate,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
