import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../settings/application/voice_settings_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../domain/level_coverage_service.dart';
import '../presentation/vocabulary_controller.dart';

final levelCoverageServiceProvider = Provider<LevelCoverageService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return LevelCoverageService(db);
});

/// Langue apprise de l'utilisateur (source : réglages TTS / onboarding).
final learningLanguageProvider = Provider<String>((ref) {
  final settings = ref.watch(voiceSettingsProvider);
  return settings.language.code;
});

/// Couverture du quota CECRL par niveau, pour la langue apprise courante.
///
/// Recalculée (et snapshot persisté en base) à chaque changement du vocabulaire
/// ou de la langue apprise.
final levelCoverageProvider = FutureProvider.family<LevelCoverage, CefrLevel>(
  (ref, level) async {
    final language = ref.watch(learningLanguageProvider);
    await ref.watch(allWordsProvider.future);

    final service = ref.watch(levelCoverageServiceProvider);
    return service.refreshCoverage(level, language: language);
  },
);
