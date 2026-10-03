import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

/// Structured result of matching handwriting candidates against a target word.
class WordMatchResult {
  final bool isMatch;
  final String? matchedText;
  final RecognitionCandidate? matchedCandidate;
  final String cleanTarget;
  final List<String> allCandidates;

  const WordMatchResult({
    required this.isMatch,
    this.matchedText,
    this.matchedCandidate,
    required this.cleanTarget,
    this.allCandidates = const [],
  });

  @override
  String toString() =>
      'WordMatchResult(isMatch: $isMatch, matchedText: $matchedText, target: $cleanTarget, candidatesCount: ${allCandidates.length})';
}

class DigitalInkRecognitionService {
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();

  /// Cache of recognizers per language tag to avoid re-initializing TFLite models on each stroke
  final Map<String, DigitalInkRecognizer> _recognizers = {};

  /// Supported languages for LexiFlow handwriting recognition
  static const List<String> requiredLanguages = ['en', 'fr'];

  /// ML Kit expects BCP-47 tags (e.g. 'en-US'); bare 'en' is not a valid model id.
  static String toModelTag(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return 'en-US';
      case 'fr':
        return 'fr-FR';
      default:
        return code;
    }
  }

  /// Check if the current platform supports ML Kit Digital Ink Recognition
  bool get isPlatformSupported {
    if (kIsWeb) return false;
    if (Platform.environment.containsKey('FLUTTER_TEST')) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Gets or creates a cached [DigitalInkRecognizer] for the given [tag]
  DigitalInkRecognizer _getRecognizer(String tag) {
    return _recognizers.putIfAbsent(tag, () {
      debugPrint('[MLKit Service] Creating new DigitalInkRecognizer instance for tag "$tag"');
      return DigitalInkRecognizer(languageCode: tag);
    });
  }

  /// Safely close a recognizer without risking Dart Future hang
  static void _safeCloseRecognizer(DigitalInkRecognizer? recognizer) {
    if (recognizer == null) return;
    try {
      recognizer.close().timeout(
        const Duration(milliseconds: 100),
        onTimeout: () => null,
      ).catchError((e) {
        debugPrint('[MLKit Service] Safe close warning (ignored): $e');
      });
    } catch (e) {
      debugPrint('[MLKit Service] Recognizer close exception (ignored): $e');
    }
  }

  /// Closes all active recognizers and cleans up resources
  void dispose() {
    debugPrint('[MLKit Service] Disposing DigitalInkRecognitionService, closing ${_recognizers.length} recognizer(s)...');
    for (final recognizer in _recognizers.values) {
      _safeCloseRecognizer(recognizer);
    }
    _recognizers.clear();
  }

  /// Checks if all required models are downloaded
  Future<bool> areModelsDownloaded() async {
    if (!isPlatformSupported) return true;

    try {
      for (final lang in requiredLanguages) {
        final tag = toModelTag(lang);
        final isDownloaded = await _modelManager.isModelDownloaded(tag);
        debugPrint('[MLKit Service] Checking model "$tag": isDownloaded=$isDownloaded');
        if (!isDownloaded) return false;
      }
      return true;
    } catch (e, st) {
      debugPrint('[MLKit Service ERROR] Error checking ML Kit models: $e\n$st');
      return false;
    }
  }

  /// Downloads required language models (en and fr)
  Future<bool> downloadRequiredModels({
    void Function(String lang, double progress)? onProgress,
  }) async {
    if (!isPlatformSupported) return true;

    try {
      for (int i = 0; i < requiredLanguages.length; i++) {
        final lang = requiredLanguages[i];
        final tag = toModelTag(lang);
        final isDownloaded = await _modelManager.isModelDownloaded(tag);

        if (!isDownloaded) {
          debugPrint('[MLKit Service] Model for $tag not downloaded. Starting download...');
          onProgress?.call(lang, i / requiredLanguages.length);
          final success = await _modelManager.downloadModel(
            tag,
            isWifiRequired: false,
          );
          if (!success) {
            debugPrint('[MLKit Service ERROR] Failed to download ML Kit model for $tag');
            return false;
          }
          debugPrint('[MLKit Service] Downloaded ML Kit model for $tag successfully');
        } else {
          debugPrint('[MLKit Service] Model for $tag already downloaded');
        }
        onProgress?.call(lang, (i + 1) / requiredLanguages.length);
      }
      return true;
    } catch (e, st) {
      debugPrint('[MLKit Service ERROR] Error downloading ML Kit models: $e\n$st');
      return false;
    }
  }

  /// Performs digital ink recognition for a given [Ink]
  Future<List<RecognitionCandidate>> recognizeInk(
    Ink ink, {
    String languageCode = 'en',
  }) async {
    if (!isPlatformSupported) {
      debugPrint('[MLKit Service] Platform not supported for ML Kit recognition');
      return [];
    }

    final stopwatch = Stopwatch()..start();
    final tag = toModelTag(languageCode);
    debugPrint('[MLKit Service] recognizeInk started: languageCode="$languageCode" (tag: "$tag"), strokesCount=${ink.strokes.length}');

    try {
      final isDownloaded = await _modelManager.isModelDownloaded(tag);
      if (!isDownloaded) {
        debugPrint('[MLKit Service] Model for $tag not downloaded yet. Downloading now...');
        final success = await _modelManager.downloadModel(
          tag,
          isWifiRequired: false,
        );
        if (!success) {
          debugPrint('[MLKit Service ERROR] Failed to download model for $tag.');
          return [];
        }
      }

      final recognizer = _getRecognizer(tag);
      debugPrint('[MLKit Service] Sending ink to recognizer...');

      // Timeout guard of 5 seconds to ensure Dart async pipeline never hangs
      final candidates = await recognizer
          .recognize(ink)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugPrint('[MLKit Service WARNING] Recognition timed out after 5s!');
              return <RecognitionCandidate>[];
            },
          );

      stopwatch.stop();
      debugPrint('[MLKit Service] ML Kit returned ${candidates.length} candidate(s) in ${stopwatch.elapsedMilliseconds}ms:');
      for (int i = 0; i < candidates.length; i++) {
        debugPrint('[MLKit Service]   #$i: "${candidates[i].text}" (score: ${candidates[i].score})');
      }

      return candidates;
    } catch (e, stack) {
      stopwatch.stop();
      debugPrint('[MLKit Service ERROR] recognizeInk failed after ${stopwatch.elapsedMilliseconds}ms: $e\n$stack');
      return [];
    }
  }

  /// Normalizes a string for lenient comparison:
  /// - Lowercase
  /// - Trim leading/trailing whitespace
  /// - Strip diacritics / accents (é -> e, à -> a, etc.)
  /// - Strip leading/trailing punctuation (like periods, quotes)
  /// - Collapse inner whitespace
  static String normalizeWord(String input, {bool removePunctuation = false}) {
    if (input.isEmpty) return '';

    // 1. Lowercase and trim
    String s = input.trim().toLowerCase();

    // 2. Strip diacritics / accents
    const withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ';
    const withoutDia = 'AAAAAAaaaaaaOOOOOOooooooEEEEeeeeCcIIIIiiiiUUUUuuuuyNn';
    for (int i = 0; i < withDia.length; i++) {
      s = s.replaceAll(withDia[i], withoutDia[i]);
    }

    // 3. Remove punctuation
    if (removePunctuation) {
      s = s.replaceAll(RegExp(r'[^\w\s]'), '');
    } else {
      // Strip leading and trailing punctuation (e.g. ".", ",", "'", '"', "-", "«", "»", "“", "”")
      s = s.replaceAll(RegExp(r"^[\.,;:!?\-_'’`«»“”\s]+|[\.,;:!?\-_'’`«»“”\s]+$"), '');
    }

    // 4. Collapse multiple spaces into one
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();

    return s;
  }

  /// Performs robust, tolerant word matching between ML Kit candidates and [targetWord]
  static WordMatchResult matchWord(
    List<RecognitionCandidate> candidates,
    String targetWord,
  ) {
    final candidateTexts = candidates.map((c) => c.text).toList();
    if (candidates.isEmpty || targetWord.trim().isEmpty) {
      debugPrint('[MLKit Matcher] Empty candidates (${candidates.length}) or empty targetWord ("$targetWord")');
      return WordMatchResult(
        isMatch: false,
        cleanTarget: normalizeWord(targetWord),
        allCandidates: candidateTexts,
      );
    }

    final cleanTarget = normalizeWord(targetWord);
    final cleanTargetNoPunct = normalizeWord(targetWord, removePunctuation: true);
    final cleanTargetNoSpace = cleanTarget.replaceAll(' ', '');

    debugPrint('[MLKit Matcher] Evaluating targetWord="$targetWord" -> normalized: "$cleanTarget" (noPunct: "$cleanTargetNoPunct")');

    for (int i = 0; i < candidates.length; i++) {
      final candidate = candidates[i];
      final cleanCand = normalizeWord(candidate.text);
      final cleanCandNoPunct = normalizeWord(candidate.text, removePunctuation: true);
      final cleanCandNoSpace = cleanCand.replaceAll(' ', '');

      debugPrint('[MLKit Matcher]   Candidate #$i: "${candidate.text}" -> normalized: "$cleanCand" (score: ${candidate.score})');

      // 1. Direct normalized match
      final isDirectMatch = cleanCand.isNotEmpty && cleanCand == cleanTarget;

      // 2. Punctuation-stripped match (e.g. candidate has trailing dot "deadline." or hyphen)
      final isPunctMatch = cleanCandNoPunct.isNotEmpty &&
          cleanTargetNoPunct.isNotEmpty &&
          cleanCandNoPunct == cleanTargetNoPunct;

      // 3. Spacing-tolerant match (e.g. user wrote "dead line" for "deadline" or vice versa)
      final isSpaceTolerantMatch = cleanCandNoSpace.isNotEmpty &&
          cleanTargetNoSpace.isNotEmpty &&
          cleanCandNoSpace == cleanTargetNoSpace;

      if (isDirectMatch || isPunctMatch || isSpaceTolerantMatch) {
        debugPrint('[MLKit Matcher] Match SUCCESS on candidate #$i ("${candidate.text}") for target "$targetWord" (mode: ${isDirectMatch ? "direct" : isPunctMatch ? "punct-stripped" : "space-tolerant"})');
        return WordMatchResult(
          isMatch: true,
          matchedText: candidate.text.trim(),
          matchedCandidate: candidate,
          cleanTarget: cleanTarget,
          allCandidates: candidateTexts,
        );
      }
    }

    debugPrint('[MLKit Matcher] Match FAILED. None of the ${candidates.length} candidate(s) matched "$cleanTarget"');
    return WordMatchResult(
      isMatch: false,
      cleanTarget: cleanTarget,
      allCandidates: candidateTexts,
    );
  }

  /// Utility to check if any candidate matches the target word case-insensitively & normalized
  static bool isWordMatch(
    List<RecognitionCandidate> candidates,
    String targetWord,
  ) {
    return matchWord(candidates, targetWord).isMatch;
  }
}
