import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import 'digital_ink_providers.dart';

class DigitalInkInitScreen extends ConsumerStatefulWidget {
  const DigitalInkInitScreen({super.key});

  @override
  ConsumerState<DigitalInkInitScreen> createState() => _DigitalInkInitScreenState();
}

class _DigitalInkInitScreenState extends ConsumerState<DigitalInkInitScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(digitalInkModelNotifierProvider);
      if (state.status == ModelInitStatus.ready) {
        if (mounted) context.go('/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final initState = ref.watch(digitalInkModelNotifierProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    ref.listen<ModelInitState>(digitalInkModelNotifierProvider, (previous, next) {
      if (next.status == ModelInitStatus.ready) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.go('/');
        });
      }
    });

    return Scaffold(
      backgroundColor: b.chalk,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: b.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: b.slate, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: b.slate,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon header
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: b.pastelYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: b.slate, width: 2),
                    ),
                    child: Icon(
                      Icons.draw_outlined,
                      size: 32,
                      color: b.slate,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'LexiFlow Canvas',
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: b.slate,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Reconnaissance Manuscrite ML Kit',
                    style: t.titleMedium?.copyWith(
                      color: b.pastelBlue,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  const BauhausRule(),
                  const SizedBox(height: 20),

                  // Status text & description
                  if (initState.status == ModelInitStatus.checking) ...[
                    Text(
                      'Vérification des modèles de langue...',
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: b.slate,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CircularProgressIndicator(color: b.slate),
                  ] else if (initState.status == ModelInitStatus.downloading) ...[
                    Text(
                      'Téléchargement du modèle (${initState.currentLanguage.toUpperCase()})...',
                      style: t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: b.slate,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Une connexion est requise pour initialiser la reconnaissance manuscrite (Anglais / Français).',
                      style: t.bodySmall?.copyWith(
                        color: b.slate.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: initState.progress,
                      backgroundColor: b.lineGrey,
                      color: b.pastelBlue,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(initState.progress * 100).toInt()}%',
                      style: t.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: b.slate,
                      ),
                    ),
                  ] else if (initState.status == ModelInitStatus.error) ...[
                    Icon(Icons.error_outline, size: 40, color: b.pastelRed),
                    const SizedBox(height: 12),
                    Text(
                      initState.errorMessage ?? 'Une erreur est survenue lors du téléchargement.',
                      style: t.bodyMedium?.copyWith(
                        color: b.pastelRed,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.go('/');
                            },
                            child: const Text('IGNORER'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              ref
                                  .read(digitalInkModelNotifierProvider.notifier)
                                  .initializeModels();
                            },
                            child: const Text('RÉESSAYER'),
                          ),
                        ),
                      ],
                    ),
                  ] else if (initState.status == ModelInitStatus.ready) ...[
                    Icon(Icons.check_circle_outline, size: 40, color: b.pastelMint),
                    const SizedBox(height: 12),
                    Text(
                      'Modèles de reconnaissance prêts !',
                      style: t.titleSmall?.copyWith(
                        color: b.slate,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () => context.go('/'),
                      child: const Text('CONTINUER'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
