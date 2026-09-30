import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import 'session_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWordsAsync = ref.watch(allWordsProvider);
    final progressRepo = ref.watch(progressRepositoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_stories, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text('LexiFlow', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Catalogue du Vocabulaire',
            onPressed: () => context.push('/vocabulary'),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome banner
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Anglais Professionnel & Quotidien',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Maîtrise B1-B2 & Rappel Espacé',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Activez votre mémoire motrice avec le tracé manuscrit et ancrez le vocabulaire dans des phrases contextualisées.',
                        style: TextStyle(color: Colors.white, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildLevelChip('Niveau B1'),
                          _buildLevelChip('Niveau B2'),
                          _buildLevelChip('Moteur SRS strict'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Statistics row
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'À réviser (Due)',
                        value: '$dueCount',
                        icon: Icons.alarm,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'Nouveaux',
                        value: '$newCount',
                        icon: Icons.fiber_new,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        context: context,
                        title: 'Total catalogue',
                        value: allWordsAsync.when(
                          data: (words) => '${words.length}',
                          loading: () => '...',
                          error: (_, __) => '0',
                        ),
                        icon: Icons.school,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Choose practice mode before launch
                const Text(
                  'Sélectionnez votre modalité d\'exercice :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: isSelected ? 3 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceContainerHighest,
                              foregroundColor: isSelected ? Colors.white : null,
                              child: Icon(icon),
                            ),
                            title: Text(
                              mode.label,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(switch (mode) {
                              PracticeMode.canvas => 'Tracé tactile/souris sur Canvas + auto-évaluation',
                              PracticeMode.cloze => 'Phrase à trou en contexte réel B1-B2',
                              PracticeMode.matching => 'Grille interactive de cartes anglais <-> français',
                            }),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                                : null,
                            onTap: () => notifier.switchMode(mode),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Launch session CTA
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.play_arrow, size: 28),
                  label: const Text(
                    'Lancer une séance d\'apprentissage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
