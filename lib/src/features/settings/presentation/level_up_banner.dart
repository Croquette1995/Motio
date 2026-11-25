import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/level_up_suggestion_controller.dart';

/// Bannière de suggestion de montée en niveau affichée sur le dashboard
/// quand les critères de maîtrise du niveau actif sont atteints. Se replie
/// après acceptation ou refus (rouvrable depuis les Paramètres).
class LevelUpBanner extends ConsumerWidget {
  const LevelUpBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(levelUpSuggestionDisplayProvider);
    if (!state.isBannerVisible) return const SizedBox.shrink();
    final suggestion = state.suggestion!;
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: b.pastelMint.withValues(alpha: 0.25),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, size: 18, color: b.slate),
              const SizedBox(width: 8),
              Text(
                'MONTÉE EN NIVEAU',
                style: t.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: b.slate.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            suggestion.message(),
            style: t.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: b.slate,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => ref
                      .read(levelUpSuggestionStateProvider.notifier)
                      .accept(),
                  child: Text('PASSER AU ${suggestion.targetLevel.code}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref
                      .read(levelUpSuggestionStateProvider.notifier)
                      .decline(),
                  child: const Text('PLUS TARD'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
