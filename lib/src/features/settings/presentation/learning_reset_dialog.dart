import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/application/category_progress_service.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import '../application/learning_reset_service.dart';
import '../application/level_up_suggestion_controller.dart';
import '../application/level_unlock_controller.dart';
import '../application/user_level_controller.dart';

/// Dialogue « Recommencer » en deux étapes :
/// 1. choix explicite de ce qui est réinitialisé (cases à cocher) ;
/// 2. récapitulatif avant l'étape finale, annulable à tout instant.
class LearningResetDialog extends ConsumerStatefulWidget {
  const LearningResetDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_) => const LearningResetDialog(),
      );

  @override
  ConsumerState<LearningResetDialog> createState() =>
      _LearningResetDialogState();
}

class _LearningResetDialogState extends ConsumerState<LearningResetDialog> {
  bool _showFinalConfirmation = false;
  bool _resetProgress = true;
  bool _deleteTatoebaWords = false;
  bool _relaunchOnboarding = true;
  bool _running = false;

  LearningResetOptions get _options => LearningResetOptions(
        resetProgress: _resetProgress,
        deleteTatoebaWords: _deleteTatoebaWords,
        relaunchOnboarding: _relaunchOnboarding,
      );

  bool get _hasSelection => _options.hasAnyAction;

  Future<void> _runReset() async {
    setState(() => _running = true);
    final options = _options;
    final navigator = Navigator.of(context, rootNavigator: true);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final router = GoRouter.maybeOf(context);

    final summary =
        await ref.read(learningResetServiceProvider).reset(options: options);

    if (options.relaunchOnboarding) {
      await ref.read(userLevelProvider.notifier).reset();
      await ref.read(learningResetServiceProvider).clearUnlocks();
    }
    ref.invalidate(allWordsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(wordProgressMapProvider);
    ref.invalidate(levelCategoryProgressProvider);
    ref.invalidate(levelUnlockStateProvider);
    ref.invalidate(levelUpSuggestionStateProvider);
    ref.invalidate(isLevelOnboardedProvider);

    navigator.pop();

    if (options.relaunchOnboarding) {
      router?.go('/onboarding');
    } else {
      messenger?.showSnackBar(
        SnackBar(content: Text(summary.message())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: b.slate, width: 1.5),
    );

    Widget checkboxTile(
      String title,
      String subtitle,
      bool value,
      ValueChanged<bool?> onChanged,
    ) {
      return CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: b.slate.withValues(alpha: 0.7),
          ),
        ),
        value: value,
        onChanged: _running ? null : onChanged,
      );
    }

    final content = _showFinalConfirmation
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Récapitulatif de l\u2019opération :',
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              if (_resetProgress)
                _recapRow(context, Icons.spa, 'La progression SRS repart de zéro.'),
              if (_deleteTatoebaWords)
                _recapRow(
                    context,
                    Icons.delete_outline,
                    'Les mots ajoutés depuis Tatoeba seront supprimés '
                    '(le référentiel embarqué est conservé).'),
              if (_relaunchOnboarding)
                _recapRow(context, Icons.school,
                    'L\u2019onboarding sera relancé : nouvelle langue et nouveau niveau de départ.'),
              const SizedBox(height: 12),
              Text(
                'Cette action est définitive.',
                style: t.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: b.pastelRed,
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisis ce que tu veux réinitialiser. Tu peux tout annuler '
                'jusqu\u2019à l\u2019étape finale. Le référentiel embarqué '
                '(vocabulaire intégré, grammaire, conjugaisons, déclinaisons) '
                'n\u2019est jamais supprimé.',
                style: t.bodySmall?.copyWith(height: 1.4),
              ),
              const SizedBox(height: 8),
              checkboxTile(
                'Réinitialiser la progression',
                'Raz de la progression SRS (révisions, maîtrise) et des leçons.',
                _resetProgress,
                (v) => setState(() => _resetProgress = v ?? false),
              ),
              checkboxTile(
                'Supprimer les mots ajoutés depuis Tatoeba',
                'Les mots que tu as ajoutés toi-même ; le référentiel intégré est conservé.',
                _deleteTatoebaWords,
                (v) => setState(() => _deleteTatoebaWords = v ?? false),
              ),
              checkboxTile(
                'Relancer l\u2019onboarding',
                'Re-choisir la langue apprise et le niveau de départ (A1→B2).',
                _relaunchOnboarding,
                (v) => setState(() => _relaunchOnboarding = v ?? false),
              ),
            ],
          );

    return AlertDialog(
      shape: shape,
      title: _showFinalConfirmation
          ? Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 20, color: b.pastelYellow),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Tout recommencer ?',
                    style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Icon(Icons.restart_alt, size: 20, color: b.slate),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Recommencer ?',
                    style:
                        t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(child: content),
      ),
      actions: _running
          ? [
              const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ]
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              if (_showFinalConfirmation)
                TextButton(
                  onPressed: () =>
                      setState(() => _showFinalConfirmation = false),
                  child: const Text('Retour'),
                ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: b.slate,
                  foregroundColor: b.cardSurface,
                ),
                onPressed: !_hasSelection
                    ? null
                    : _showFinalConfirmation
                        ? _runReset
                        : () =>
                            setState(() => _showFinalConfirmation = true),
                child: Text(_showFinalConfirmation ? 'RECOMMENCER' : 'CONTINUER'),
              ),
            ],
    );
  }

  Widget _recapRow(BuildContext context, IconData icon, String text) {
    final b = context.bauhaus;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: b.slate),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
