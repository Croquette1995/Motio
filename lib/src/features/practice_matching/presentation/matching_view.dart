import 'dart:math';
import 'package:flutter/material.dart';
import '../../vocabulary/domain/word.dart';

enum MatchingCardType { term, translation }

class MatchingCardItem {
  final int id;
  final int wordId;
  final String text;
  final MatchingCardType type;
  bool isMatched;
  bool isSelected;

  MatchingCardItem({
    required this.id,
    required this.wordId,
    required this.text,
    required this.type,
    this.isMatched = false,
    this.isSelected = false,
  });
}

class MatchingPracticeView extends StatefulWidget {
  final List<Word> words;
  final int pairCount; // 4, 6 or 8
  final VoidCallback? onComplete;

  const MatchingPracticeView({
    super.key,
    required this.words,
    this.pairCount = 6,
    this.onComplete,
  });

  @override
  State<MatchingPracticeView> createState() => _MatchingPracticeViewState();
}

class _MatchingPracticeViewState extends State<MatchingPracticeView> {
  late List<MatchingCardItem> _cards;
  MatchingCardItem? _firstSelected;
  bool _isProcessing = false;
  int _matchedPairs = 0;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    final effectiveCount = min(widget.pairCount, widget.words.length);
    final selectedWords = (List<Word>.from(widget.words)..shuffle()).take(effectiveCount).toList();

    _cards = [];
    int idCounter = 0;
    for (final word in selectedWords) {
      _cards.add(
        MatchingCardItem(
          id: idCounter++,
          wordId: word.id,
          text: word.term,
          type: MatchingCardType.term,
        ),
      );
      _cards.add(
        MatchingCardItem(
          id: idCounter++,
          wordId: word.id,
          text: word.translation,
          type: MatchingCardType.translation,
        ),
      );
    }
    _cards.shuffle();
    _firstSelected = null;
    _isProcessing = false;
    _matchedPairs = 0;
  }

  void _handleCardTap(MatchingCardItem card) async {
    if (_isProcessing || card.isMatched || card.isSelected) return;

    setState(() {
      card.isSelected = true;
    });

    if (_firstSelected == null) {
      _firstSelected = card;
    } else {
      _isProcessing = true;
      final first = _firstSelected!;
      final isMatch = first.wordId == card.wordId && first.type != card.type;

      if (isMatch) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        setState(() {
          first.isMatched = true;
          card.isMatched = true;
          first.isSelected = false;
          card.isSelected = false;
          _firstSelected = null;
          _isProcessing = false;
          _matchedPairs++;
        });

        final targetPairs = _cards.length ~/ 2;
        if (_matchedPairs >= targetPairs) {
          widget.onComplete?.call();
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
        if (!mounted) return;
        setState(() {
          first.isSelected = false;
          card.isSelected = false;
          _firstSelected = null;
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPairs = _cards.length ~/ 2;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Paires trouvées : $_matchedPairs / $totalPairs',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Réinitialiser la grille',
                onPressed: () => setState(_initializeCards),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;

                Color bgColor;
                Color textColor;
                if (card.isMatched) {
                  bgColor = Colors.green.withValues(alpha: 0.2);
                  textColor = Colors.green;
                } else if (card.isSelected) {
                  bgColor = Theme.of(context).colorScheme.primaryContainer;
                  textColor = Theme.of(context).colorScheme.onPrimaryContainer;
                } else {
                  bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
                  textColor = Theme.of(context).colorScheme.onSurface;
                }

                return GestureDetector(
                  onTap: () => _handleCardTap(card),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: card.isSelected
                            ? Theme.of(context).colorScheme.primary
                            : (card.isMatched
                                ? Colors.green
                                : Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                        width: card.isSelected || card.isMatched ? 2 : 1,
                      ),
                      boxShadow: card.isMatched
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Text(
                      card.text,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        decoration: card.isMatched ? TextDecoration.lineThrough : null,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
