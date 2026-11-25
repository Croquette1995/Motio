import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../learning_engine/presentation/session_controller.dart';
import '../../settings/application/level_unlock_controller.dart';
import '../../settings/application/user_level_controller.dart';
import '../../settings/application/voice_settings_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../../settings/presentation/level_unlock_dialog.dart';
import '../application/category_progress_service.dart';
import '../domain/word.dart';
import 'vocabulary_controller.dart';
import 'widgets/tatoeba_examples_sheet.dart';

class LevelDomainsScreen extends ConsumerStatefulWidget {
  const LevelDomainsScreen({super.key});

  @override
  ConsumerState<LevelDomainsScreen> createState() => _LevelDomainsScreenState();
}

class _LevelDomainsScreenState extends ConsumerState<LevelDomainsScreen> {
  CefrLevel? _selectedLevel;
  final Set<String> _expandedCategories = {};

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final activeUserLevel = ref.watch(userLevelProvider);
    final unlockState = ref.watch(levelUnlockDisplayProvider);
    final currentLevel = _selectedLevel ?? activeUserLevel;

    final progressAsync = ref.watch(levelCategoryProgressProvider(currentLevel));
    final progressMap = ref.watch(wordProgressMapProvider).valueOrNull ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: b.pastelMint,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'DOMAINES & PROGRESSION',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
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
      body: Column(
        children: [
          // Sélecteur de niveau CECRL (Tabs Bauhaus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: b.cardSurface,
              border: Border(bottom: BorderSide(color: b.slate, width: 1.5)),
            ),
            child: Row(
              children: CefrLevel.values.map((lvl) {
                final isSelected = currentLevel == lvl;
                final unlocked = unlockState.isUnlocked(lvl);
                final pastel = switch (lvl) {
                  CefrLevel.a1 => b.pastelMint,
                  CefrLevel.a2 => b.pastelBlue,
                  CefrLevel.b1 => b.pastelYellow,
                  CefrLevel.b2 => b.pastelRed,
                };

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        if (!unlocked) {
                          LevelUnlockDialog.show(context, lvl);
                          return;
                        }
                        setState(() {
                          _selectedLevel = lvl;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!unlocked) ...[
                                Icon(Icons.lock, size: 12, color: b.slate),
                                const SizedBox(width: 2),
                              ],
                              Text(
                                lvl.code,
                                style: TextStyle(
                                  color: b.slate,
                                  fontWeight:
                                      isSelected ? FontWeight.w800 : FontWeight.w600,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Contenu principal avec synthèse et liste des domaines
          Expanded(
            child: progressAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Erreur lors du calcul de la progression: $err'),
                ),
              ),
              data: (data) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Synthèse globale du niveau
                    _buildLevelSummaryCard(context, data, activeUserLevel),

                    const SizedBox(height: 20),

                    // Titre section domaines
                    Row(
                      children: [
                        Text(
                          'DOMAINES (${data.categories.length})',
                          style: t.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: b.slate.withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Niveau ${data.level.code}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: b.slate.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    if (data.categories.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: b.chalk,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: b.lineGrey, width: 1),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.inbox, size: 40, color: b.slate.withValues(alpha: 0.5)),
                            const SizedBox(height: 10),
                            Text(
                              'Aucun mot répertorié dans ce niveau pour l\'instant.',
                              style: t.bodyMedium?.copyWith(
                                color: b.slate.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: b.slate,
                                foregroundColor: b.cardSurface,
                              ),
                              icon: const Icon(Icons.travel_explore, size: 18),
                              label: const Text('Explorer Tatoeba pour ce niveau'),
                              onPressed: () => context.push('/tatoeba'),
                            ),
                          ],
                        ),
                      ),

                    // Liste des catégories
                    for (final cat in data.categories)
                      _buildCategoryCard(context, cat, progressMap),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Carte de synthèse globale pour le niveau sélectionné
  Widget _buildLevelSummaryCard(
    BuildContext context,
    LevelProgressData data,
    CefrLevel activeUserLevel,
  ) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.level.label.toUpperCase(),
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: b.slate,
                  ),
                ),
              ),
              // Marqueur « révision » pour un niveau déjà couvert
              if (data.level.index < activeUserLevel.index)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: b.pastelBlue,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: b.slate, width: 1),
                    ),
                    child: Text(
                      'RÉVISION ${data.level.code}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: b.pastelYellow,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: b.slate, width: 1),
                ),
                child: Text(
                  '${data.totalWords} / ~${data.targetWords} mots',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.level.description,
            style: t.bodySmall?.copyWith(color: b.slate.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 12),

          // Barre d'avancement du niveau
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.levelCompletionRate,
              minHeight: 10,
              backgroundColor: b.chalk,
              valueColor: AlwaysStoppedAnimation<Color>(b.slate),
            ),
          ),
          const SizedBox(height: 8),

          // Décompte par statuts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBadge(b.pastelMint, 'MAÎTRISÉS : ${data.totalMastered}'),
              _buildStatBadge(b.pastelYellow, 'RÉVISION : ${data.totalReview}'),
              _buildStatBadge(b.pastelBlue, 'EN COURS : ${data.totalLearning}'),
              _buildStatBadge(b.chalk, 'NOUVEAUX : ${data.totalNew}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(Color bg, String text) {
    final b = context.bauhaus;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: b.slate, width: 0.8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
      ),
    );
  }

  /// Carte d'une catégorie / domaine avec barre d'évolution et liste dépliable des mots
  Widget _buildCategoryCard(
    BuildContext context,
    CategoryProgressData cat,
    Map<int, String> progressMap,
  ) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final isExpanded = _expandedCategories.contains(cat.categoryName);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Column(
        children: [
          // En-tête cliquable pour déplier/replier
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedCategories.remove(cat.categoryName);
                } else {
                  _expandedCategories.add(cat.categoryName);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cat.domain.accentColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: b.slate, width: 1.2),
                        ),
                        child: Icon(cat.domain.icon, size: 20, color: b.slate),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.domain.labelFr,
                              style: t.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: b.slate,
                              ),
                            ),
                            Text(
                              '${cat.categoryName} · ${cat.totalCount} mot(s)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: b.slate.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cat.explorationRate > 0 ? b.pastelMint : b.chalk,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.slate, width: 1),
                        ),
                        child: Text(
                          cat.statusLabel.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 9),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: b.slate,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Barre de progression multi-statuts de la catégorie
                  _buildSegmentedProgressBar(context, cat),

                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Maîtrise : ${(cat.masteryRate * 100).toInt()}% (${cat.masteredCount}/${cat.totalCount})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: b.slate.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '${cat.totalCount - cat.newCount} étudié(s)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: b.slate.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Liste dépliée des cartes d'apprentissage
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1),
            Container(
              color: b.chalk.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  for (final word in cat.words)
                    _buildWordLearningCard(context, word, progressMap[word.id] ?? 'Nouveau'),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: b.slate,
                      side: BorderSide(color: b.slate, width: 1.2),
                    ),
                    icon: const Icon(Icons.travel_explore, size: 16),
                    label: Text('Enrichir "${cat.domain.labelFr}" via Tatoeba'),
                    onPressed: () {
                      context.push('/tatoeba');
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Barre de progression segmentée Bauhaus (Maîtrisé, Révision, En cours, Nouveau)
  Widget _buildSegmentedProgressBar(BuildContext context, CategoryProgressData cat) {
    final b = context.bauhaus;
    if (cat.totalCount == 0) return const SizedBox.shrink();

    final fMastered = cat.masteredCount / cat.totalCount;
    final fReview = cat.reviewCount / cat.totalCount;
    final fLearning = cat.learningCount / cat.totalCount;
    final fNew = cat.newCount / cat.totalCount;

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: b.chalk,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: b.slate, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Row(
          children: [
            if (fMastered > 0)
              Expanded(
                flex: (fMastered * 100).toInt(),
                child: Container(color: b.pastelMint),
              ),
            if (fReview > 0)
              Expanded(
                flex: (fReview * 100).toInt(),
                child: Container(color: b.pastelYellow),
              ),
            if (fLearning > 0)
              Expanded(
                flex: (fLearning * 100).toInt(),
                child: Container(color: b.pastelBlue),
              ),
            if (fNew > 0)
              Expanded(
                flex: (fNew * 100).toInt(),
                child: Container(color: b.chalk),
              ),
          ],
        ),
      ),
    );
  }

  /// Carte d'apprentissage individuelle pour un mot du domaine
  Widget _buildWordLearningCard(BuildContext context, Word word, String status) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final voiceNotifier = ref.read(voiceSettingsProvider.notifier);

    final (Color statusBg, Color statusFg) = switch (status) {
      'Maîtrisé' => (b.pastelMint, b.slate),
      'À réviser' => (b.pastelRed, b.slate),
      'En révision' => (b.pastelYellow, b.slate),
      'En apprentissage' => (b.pastelBlue, b.slate),
      _ => (b.chalk, b.slate),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: b.slate, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                word.term,
                style: t.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: b.slate,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: b.chalk,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: b.lineGrey, width: 1),
                ),
                child: Text(
                  word.pos.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: b.slate.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: b.slate, width: 0.8),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: statusFg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            word.translation,
            style: t.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: b.slate.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: b.chalk,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: b.lineGrey, width: 1),
            ),
            child: Text(
              word.contextSentence,
              style: t.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: b.slate.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.volume_up, size: 18),
                tooltip: 'Écouter le mot',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.only(right: 12),
                onPressed: () {
                  voiceNotifier.speak(word.term);
                },
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.library_books, size: 14, color: b.slate),
                label: Text(
                  'Autres exemples Tatoeba',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: b.slate),
                ),
                onPressed: () {
                  TatoebaExamplesSheet.show(context, word);
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_note, size: 20),
                tooltip: 'S\'entraîner sur cette carte',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await ref.read(sessionControllerProvider.notifier).startSession(
                    maxCards: 5,
                    maxNewCards: 2,
                  );
                  if (context.mounted) {
                    context.push('/session');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
