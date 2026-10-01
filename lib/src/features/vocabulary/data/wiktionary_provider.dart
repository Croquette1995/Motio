import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/word_details.dart';
import 'wiktionary_service.dart';

final wiktionaryServiceProvider = Provider<WiktionaryService>((ref) {
  return WiktionaryService();
});

final wordDetailsProvider = FutureProvider.family<WordDetails, String>((ref, term) async {
  final service = ref.watch(wiktionaryServiceProvider);
  return service.fetchWordDetails(term);
});
