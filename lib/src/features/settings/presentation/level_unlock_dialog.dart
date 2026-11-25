import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/level_unlock_controller.dart';
import '../domain/cefr_level.dart';

/// Dialogue affichant le critère de déblocage d'un niveau supérieur verrouillé,
/// avec un déverrouillage manuel explicite (« Je suis certain de mon niveau »).
class LevelUnlockDialog extends ConsumerWidget {
  const LevelUnlockDialog({super.key, required this.level});

  final CefrLevel level;

  static Future<void> show(BuildContext context, CefrLevel level) =>
      showDialog<void>(context: context, builder: (_) => LevelUnlockDialog(level: level));

  Future<void> _confirmManualUnlock(BuildContext context, WidgetRef ref) async {
    final b = context.bauhaus;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Débloquer le ${level.code} immédiatement ?'),
        content: Text(
          'Vous accéderez à tout le contenu du ${level.code} sans avoir atteint '
          'le critère de maîtrise. Cette action est définitive.',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: b.slate,
              foregroundColor: b.cardSurface,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('Débloquer le ${level.code}'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(levelUnlockStateProvider.notifier).unlockManually(level);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final requirement = ref
        .watch(levelUnlockStateProvider)
        .valueOrNull
        ?.requirementFor(level);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: b.slate, width: 1.5),
      ),
      title: Row(
        children: [
          Icon(Icons.lock, size: 20, color: b.slate),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Niveau ${level.code} verrouillé',
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      content: requirement == null
          ? const SizedBox(
              width: 220,
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  requirement.message(target: level),
                  style: t.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: requirement.progress,
                    minHeight: 8,
                    backgroundColor: b.chalk,
                    valueColor: AlwaysStoppedAnimation<Color>(b.slate),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${requirement.masteredWords}/${requirement.requiredWords} mots maîtrisés',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: b.slate.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Plus tard'),
        ),
        TextButton(
          onPressed: requirement == null
              ? null
              : () => _confirmManualUnlock(context, ref),
          child: const Text(
            'Je suis certain de mon niveau',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
