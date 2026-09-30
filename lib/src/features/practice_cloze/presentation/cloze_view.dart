import 'package:flutter/material.dart';
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
    final pattern = RegExp(RegExp.escape(widget.word.term), caseSensitive: false);
    final sentenceWithBlank = widget.word.contextSentence.replaceAll(pattern, '__________');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(widget.word.category),
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
                  const SizedBox(height: 16),
                  Text(
                    _isAnswered ? widget.word.contextSentence : sentenceWithBlank,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Traduction : ${widget.word.translation}',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Choisissez le mot qui complète la phrase :',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._choiceOptions.map((option) {
            Color? tileColor;
            if (_isAnswered) {
              if (option.toLowerCase() == widget.word.term.toLowerCase()) {
                tileColor = Colors.green.withValues(alpha: 0.2);
              } else {
                tileColor = Colors.red.withValues(alpha: 0.1);
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: tileColor,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.centerLeft,
                ),
                onPressed: _isAnswered ? null : () => _validateSelection(option),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      option,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    if (_isAnswered && option.toLowerCase() == widget.word.term.toLowerCase())
                      const Icon(Icons.check_circle, color: Colors.green)
                  ],
                ),
              ),
            );
          }),
          if (_isAnswered) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isCorrect
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isCorrect ? Icons.check_circle : Icons.info_outline,
                    color: _isCorrect ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isCorrect
                          ? 'Excellent ! Le mot a bien été mémorisé en contexte.'
                          : 'Rappel : "${widget.word.term}" = ${widget.word.translation}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green.shade800 : Colors.orange.shade800,
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
