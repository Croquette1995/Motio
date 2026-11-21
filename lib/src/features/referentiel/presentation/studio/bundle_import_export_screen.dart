import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/bauhaus_theme.dart';
import '../../application/ai_prompt_generator.dart';
import '../../application/referentiel_controllers.dart';
import '../../application/referentiel_import_service.dart';

class BundleImportExportScreen extends ConsumerStatefulWidget {
  const BundleImportExportScreen({super.key});

  @override
  ConsumerState<BundleImportExportScreen> createState() => _BundleImportExportScreenState();
}

class _BundleImportExportScreenState extends ConsumerState<BundleImportExportScreen> {
  final TextEditingController _jsonCtrl = TextEditingController();
  ImportReport? _report;
  bool _isBusy = false;

  @override
  void dispose() {
    _jsonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langAsync = ref.watch(activeLanguageRecordProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return langAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('IMPORT / EXPORT & IA')),
        body: Center(child: CircularProgressIndicator(color: b.slate)),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (lang) {
        if (lang == null) {
          return const Scaffold(body: Center(child: Text('Aucune langue active.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'BUNDLE ${lang.code.toUpperCase()} · IMPORT / EXPORT',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: const Text('COPIER LE PROMPT IA'),
                    onPressed: () async {
                      final repo = ref.read(referentielRepositoryProvider);
                      final conjs = await repo.getConjugations(lang.id, publishedOnly: false);
                      final decls = await repo.getDeclensions(lang.id, publishedOnly: false);
                      final lessons = await repo.getLessons(lang.id, publishedOnly: false);
                      final prompt = AiPromptGenerator.generateSystemPrompt(
                        language: lang,
                        sampleConjugations: conjs,
                        sampleDeclensions: decls,
                        sampleLessons: lessons,
                      );
                      await Clipboard.setData(ClipboardData(text: prompt));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Prompt IA (${lang.code}) copié dans le presse-papiers.')),
                        );
                      }
                    },
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('EXPORTER JSON'),
                    onPressed: () async {
                      final repo = ref.read(referentielRepositoryProvider);
                      final bundle = await repo.exportBundle(lang, publishedOnly: false);
                      final pretty = const JsonEncoder.withIndent('  ').convert(bundle);
                      _jsonCtrl.text = pretty;
                      await Clipboard.setData(ClipboardData(text: pretty));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Bundle JSON exporté et copié.')),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _jsonCtrl,
                maxLines: 14,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                decoration: const InputDecoration(
                  labelText: 'JSON Bundle v1.3 (coller ou éditer)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.upload_file),
                label: Text(_isBusy ? 'IMPORTATION...' : 'IMPORTER (UPSERT)'),
                onPressed: _isBusy
                    ? null
                    : () async {
                        setState(() => _isBusy = true);
                        final service = ref.read(referentielImportServiceProvider);
                        final rep = await service.importBundleJsonString(
                          _jsonCtrl.text,
                          targetLanguage: lang,
                        );
                        ref.invalidate(referentielConjugationsProvider);
                        ref.invalidate(referentielDeclensionsProvider);
                        ref.invalidate(referentielLessonsProvider);
                        if (mounted) {
                          setState(() {
                            _report = rep;
                            _isBusy = false;
                          });
                        }
                      },
              ),
              if (_report != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _report!.success
                        ? b.pastelMint.withValues(alpha: 0.25)
                        : b.pastelRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: b.slate, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _report!.success ? 'IMPORT RÉUSSI (BROUILLONS)' : 'ERREURS BLOQUANTES',
                        style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      if (_report!.success)
                        Text(
                          'Upsert : ${_report!.upsertedConjugations} conjugaison(s), '
                          '${_report!.upsertedDeclensions} déclinaison(s), '
                          '${_report!.upsertedLessons} leçon(s).',
                        ),
                      if (_report!.errors.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ..._report!.errors.map((e) => Text('• $e', style: const TextStyle(fontSize: 12))),
                      ],
                      if (_report!.warnings.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Avertissements de complétude :', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        ..._report!.warnings.map((w) => Text('• $w', style: const TextStyle(fontSize: 12))),
                      ],
                      if (_report!.createdSkeletons.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Squelettes créés : ${_report!.createdSkeletons.join(', ')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                      if (_report!.unpublishedRecords.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Repassés en brouillon : ${_report!.unpublishedRecords.join(', ')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
