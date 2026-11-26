import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../settings/application/level_unlock_controller.dart';
import '../../settings/application/user_level_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../../settings/presentation/level_unlock_dialog.dart';
import '../../settings/presentation/level_up_banner.dart';
import '../../vocabulary/application/level_coverage_controller.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import 'session_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWordsAsync = ref.watch(allWordsProvider);
    final progressRepo = ref.watch(progressRepositoryProvider);
    final userLevel = ref.watch(userLevelProvider);
    final coverageAsync = ref.watch(levelCoverageProvider(userLevel));
    final unlockState = ref.watch(levelUnlockDisplayProvider);
    // Watch wordProgressMapProvider so the dashboard refreshes automatically on progress updates
    ref.watch(wordProgressMapProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: b.pastelRed,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Motio',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.travel_explore),
            tooltip: 'Explorer Tatoeba',
            onPressed: () => context.push('/tatoeba'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([
          progressRepo.getDueProgresses(limit: 50),
          progressRepo.getNewProgresses(limit: 50),
        ]),
        builder: (context, snapshot) {
          final dueCount = snapshot.hasData ? (snapshot.data![0]).length : 0;
          final newCount = snapshot.hasData ? (snapshot.data![1]).length : 0;

          final wordsInActiveLevel = allWordsAsync.when(
            data: (words) => words.where((w) => w.level.toUpperCase() == userLevel.code).length,
            loading: () => 0,
            error: (_, __) => 0,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LevelUpBanner(),

                // Welcome banner - Bauhaus Pastel Hero Card avec sélecteur de niveau CECRL
                Container(
                  padding: const EdgeInsets.all(22.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NIVEAU ACTUEL',
                            style: t.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.8,
                              color: b.slate.withValues(alpha: 0.6),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: b.chalk,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: b.lineGrey, width: 1),
                            ),
                            child: Text(
                              'Quota : ${userLevel.levelWordQuota} mots',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: b.slate.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userLevel.label,
                        style: t.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: b.slate,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        userLevel.description,
                        style: t.bodyMedium?.copyWith(height: 1.35),
                      ),
                      const SizedBox(height: 14),
                      // Suivi de couverture du quota CECRL du niveau actif,
                      // pour la langue apprise courante.
                      coverageAsync.when(
                        data: (coverage) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'COUVERTURE ${coverage.languageCode.toUpperCase()}',
                                  style: t.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: b.slate.withValues(alpha: 0.6),
                                  ),
                                ),
                                Text(
                                  '${coverage.wordCount} / ${coverage.quota} mots · reste ${coverage.remainingWords}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: b.slate.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: coverage.coverageRate,
                                minHeight: 10,
                                backgroundColor: b.chalk,
                                valueColor: AlwaysStoppedAnimation<Color>(b.pastelMint),
                              ),
                            ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (err, _) => Text(
                          'Couverture indisponible : $err',
                          style: t.bodySmall?.copyWith(
                            color: b.slate.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Sélecteur interactif des niveaux CECRL
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: CefrLevel.values.map((lvl) {
                          final isSelected = userLevel == lvl;
                          final pastel = switch (lvl) {
                            CefrLevel.a1 => b.pastelMint,
                            CefrLevel.a2 => b.pastelBlue,
                            CefrLevel.b1 => b.pastelYellow,
                            CefrLevel.b2 => b.pastelRed,
                          };

                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              if (!unlockState.isUnlocked(lvl)) {
                                LevelUnlockDialog.show(context, lvl);
                                return;
                              }
                              ref.read(userLevelProvider.notifier).setLevel(lvl);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? pastel : b.chalk,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: b.slate,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: b.slate,
                                          offset: const Offset(2, 2),
                                          blurRadius: 0,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    Icon(Icons.check, size: 12, color: b.slate),
                                    const SizedBox(width: 4),
                                  ],
                                  if (!unlockState.isUnlocked(lvl)) ...[
                                    Icon(Icons.lock, size: 12, color: b.slate),
                                    const SizedBox(width: 2),
                                  ],
                                  Text(
                                    lvl.code,
                                    style: TextStyle(
                                      color: b.slate,
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Statistics row - Bauhaus metric cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'À réviser',
                        value: '$dueCount',
                        icon: Icons.alarm,
                        accentColor: b.pastelRed,
                        onTap: () {
                          ref.read(selectedStatusFilterProvider.notifier).select('À réviser');
                          ref.read(selectedCategoryProvider.notifier).select(null);
                          ref.read(selectedLevelFilterProvider.notifier).select(userLevel.code);
                          context.go('/vocabulary');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'Nouveaux',
                        value: '$newCount',
                        icon: Icons.fiber_new,
                        accentColor: b.pastelBlue,
                        onTap: () {
                          ref.read(selectedStatusFilterProvider.notifier).select('Nouveau');
                          ref.read(selectedCategoryProvider.notifier).select(null);
                          ref.read(selectedLevelFilterProvider.notifier).select(userLevel.code);
                          context.go('/vocabulary');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'Niveau ${userLevel.code}',
                        value: '$wordsInActiveLevel',
                        icon: Icons.school,
                        accentColor: b.pastelYellow,
                        onTap: () {
                          ref.read(selectedStatusFilterProvider.notifier).select(null);
                          ref.read(selectedCategoryProvider.notifier).select(null);
                          ref.read(selectedLevelFilterProvider.notifier).select(userLevel.code);
                          context.go('/vocabulary');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Carte d'accès direct aux Domaines & Évolution de la catégorie
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: b.cardSurface,
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: b.pastelMint,
                          shape: BoxShape.circle,
                          border: Border.all(color: b.slate, width: 1.2),
                        ),
                        child: Icon(Icons.pie_chart, color: b.slate, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DOMAINES & PROGRESSION',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: b.slate.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Explorer les catégories du niveau ${userLevel.code}',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: b.slate,
                          foregroundColor: b.cardSurface,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                        onPressed: () => context.go('/domains'),
                        child: const Text('VOIR'),
                      ),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: BauhausRule(),
                ),

                // Choose practice mode before launch
                Text(
                  'EXERCICES',
                  style: t.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: b.slate.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Choisissez un mode d\'exercice', style: t.headlineSmall),
                const SizedBox(height: 12),

                Consumer(
                  builder: (context, ref, _) {
                    final sessionState = ref.watch(sessionControllerProvider);
                    final notifier = ref.read(sessionControllerProvider.notifier);

                    return Column(
                      children: PracticeMode.values.map((mode) {
                        final isSelected = sessionState.currentMode == mode;
                        final icon = switch (mode) {
                          PracticeMode.canvas => Icons.draw,
                          PracticeMode.cloze => Icons.text_fields,
                          PracticeMode.matching => Icons.grid_view,
                        };

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => notifier.switchMode(mode),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: b.cardSurface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: b.slate,
                                  width: isSelected ? 2.0 : 1.2,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: b.slate,
                                          offset: const Offset(3, 3),
                                          blurRadius: 0,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isSelected ? b.pastelBlue : b.chalk,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: b.slate, width: 1.2),
                                    ),
                                    child: Icon(icon, color: b.slate, size: 20),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mode.label,
                                          style: TextStyle(
                                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                            fontSize: 15,
                                            color: b.slate,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          switch (mode) {
                                            PracticeMode.canvas => 'Écrire le mot à la main et vérifier',
                                            PracticeMode.cloze => 'Compléter une phrase avec le bon mot',
                                            PracticeMode.matching => 'Associer chaque mot anglais à sa traduction',
                                          },
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: b.slate.withValues(alpha: 0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: b.slate,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        size: 14,
                                        color: b.cardSurface,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Launch session CTA
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: b.slate,
                    foregroundColor: b.cardSurface,
                    shape: bauhausBorder(radius: 10, color: b.slate),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 24),
                  label: Text(
                    dueCount > 0
                        ? 'LANCER LA SÉANCE ($dueCount À RÉVISER)'
                        : 'LANCER UNE SÉANCE',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(sessionControllerProvider.notifier).startSession(
                          maxCards: 20,
                          maxNewCards: 5,
                        );
                    if (context.mounted) {
                      context.push('/session');
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    VoidCallback? onTap,
  }) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: b.cardSurface,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: b.slate, width: 1.0),
                  ),
                  child: Icon(icon, color: b.slate, size: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: t.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: b.slate,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title.toUpperCase(),
                  style: t.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: b.slate.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
