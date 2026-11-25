import 'package:flutter/material.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../settings/domain/cefr_level.dart';
import '../application/placement_quiz_service.dart';

/// Test de positionnement intégré à l'onboarding : le quiz présente les mots
/// niveau par niveau, du plus courant au plus rare, et s'arrête dès qu'un
/// niveau n'est plus reconnu à 60 %.
class PlacementQuizCard extends StatefulWidget {
  const PlacementQuizCard({
    super.key,
    required this.onCompleted,
    required this.onCancelled,
  });

  /// Appelé quand l'utilisateur valide le niveau recommandé ou passe le test.
  final ValueChanged<CefrLevel> onCompleted;

  /// Appelé quand l'utilisateur revient au formulaire ; le niveau proposé
  /// (si le test a abouti) pré-sélectionne l'écran de confirmation.
  final ValueChanged<CefrLevel?> onCancelled;

  @override
  State<PlacementQuizCard> createState() => _PlacementQuizCardState();
}

class _PlacementQuizCardState extends State<PlacementQuizCard> {
  late final List<List<PlacementQuizWord>> _blocks;
  int _blockIndex = 0;
  int _wordIndex = 0;
  final Map<CefrLevel, int> _knownByLevel = {};
  CefrLevel? _recommendation;

  @override
  void initState() {
    super.initState();
    _blocks = PlacementQuizService.blocks();
  }

  List<PlacementQuizWord> get _currentBlock => _blocks[_blockIndex];

  PlacementQuizWord get _currentWord => _currentBlock[_wordIndex];

  void _answer(bool known) {
    final level = _currentWord.level;
    if (known) {
      _knownByLevel[level] = (_knownByLevel[level] ?? 0) + 1;
    }
    if (_wordIndex + 1 < _currentBlock.length) {
      setState(() => _wordIndex++);
      return;
    }
    final total = _currentBlock.length;
    final ratio =
        total == 0 ? 0.0 : (_knownByLevel[level] ?? 0) / total;
    final passed = ratio >= PlacementQuizService.requiredRecognitionRate;
    if (passed && _blockIndex + 1 < _blocks.length) {
      setState(() {
        _blockIndex++;
        _wordIndex = 0;
      });
      return;
    }
    setState(() {
      _recommendation = PlacementQuizService.recommendLevel(_knownByLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    if (_recommendation != null) {
      final rec = _recommendation!;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'NIVEAU RECOMMANDÉ',
            style: t.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: b.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            rec.code,
            style: t.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: b.pastelBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            rec.label,
            style: t.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: b.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => widget.onCompleted(rec),
            child: const Text('UTILISER CE NIVEAU'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => widget.onCancelled(rec),
            child: const Text('CHOISIR UN AUTRE NIVEAU'),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'TEST DE POSITIONNEMENT',
                style: t.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: b.slate,
                ),
              ),
            ),
            TextButton(
              onPressed: () => widget.onCompleted(CefrLevel.a1),
              child: const Text('PASSER'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Niveau ${_currentWord.level.code} · mot ${_wordIndex + 1}/${_currentBlock.length}',
          style: t.bodySmall?.copyWith(
            color: b.slate.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: b.chalk,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: b.lineGrey),
          ),
          child: Column(
            children: [
              Text(
                _currentWord.term,
                style: t.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: b.slate,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connais-tu ce mot ?',
                style: t.bodyMedium?.copyWith(
                  color: b.slate.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _answer(false),
                child: const Text('JE NE CONNAIS PAS'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => _answer(true),
                child: const Text('JE CONNAIS'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
