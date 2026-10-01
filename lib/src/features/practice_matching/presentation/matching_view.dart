import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/bauhaus_theme.dart';
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
  late List<MatchingCardItem> _leftCards;
  late List<MatchingCardItem> _rightCards;
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

    _leftCards = [];
    _rightCards = [];
    int idCounter = 0;

    for (final word in selectedWords) {
      _leftCards.add(
        MatchingCardItem(
          id: idCounter++,
          wordId: word.id,
          text: word.term,
          type: MatchingCardType.term,
        ),
      );
      _rightCards.add(
        MatchingCardItem(
          id: idCounter++,
          wordId: word.id,
          text: word.translation,
          type: MatchingCardType.translation,
        ),
      );
    }

    _leftCards.shuffle();
    _rightCards.shuffle();
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
        await Future.delayed(const Duration(milliseconds: 250));
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

        final targetPairs = _leftCards.length;
        if (_matchedPairs >= targetPairs) {
          widget.onComplete?.call();
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 600));
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

  Widget _buildCardTile(MatchingCardItem card) {
    final b = context.bauhaus;

    Color bgColor;
    Color textColor;
    if (card.isMatched) {
      bgColor = b.pastelMint;
      textColor = b.slate.withValues(alpha: 0.6);
    } else if (card.isSelected) {
      bgColor = b.pastelYellow;
      textColor = b.slate;
    } else {
      bgColor = b.cardSurface;
      textColor = b.slate;
    }

    return GestureDetector(
      onTap: () => _handleCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: b.slate,
            width: card.isSelected ? 2.0 : 1.2,
          ),
          boxShadow: card.isMatched
              ? []
              : [
                  BoxShadow(
                    color: b.slate,
                    offset: const Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Text(
          card.text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textColor,
            decoration: card.isMatched ? TextDecoration.lineThrough : null,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final totalPairs = _leftCards.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PAIRES ASSOCIÉES : $_matchedPairs / $totalPairs',
                style: t.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: b.slate,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: 'Réinitialiser',
                onPressed: () => setState(_initializeCards),
              ),
            ],
          ),
        ),

        // Headers for Columns
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: b.pastelBlue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Text(
                    'ANGLAIS',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      fontSize: 12,
                      color: b.slate,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: b.pastelYellow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Text(
                    'FRANÇAIS',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      fontSize: 12,
                      color: b.slate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column (English Terms)
                Expanded(
                  child: ListView.separated(
                    itemCount: _leftCards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _buildCardTile(_leftCards[index]),
                  ),
                ),
                const SizedBox(width: 12),
                // Right Column (French Translations)
                Expanded(
                  child: ListView.separated(
                    itemCount: _rightCards.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _buildCardTile(_rightCards[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
