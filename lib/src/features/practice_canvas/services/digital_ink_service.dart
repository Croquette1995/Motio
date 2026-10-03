import 'package:flutter/foundation.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';

class DigitalInkRecognitionService {
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();

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
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Checks if all required models are downloaded
  Future<bool> areModelsDownloaded() async {
    if (!isPlatformSupported) return true;

    try {
      for (final lang in requiredLanguages) {
        final isDownloaded = await _modelManager.isModelDownloaded(toModelTag(lang));
        if (!isDownloaded) return false;
      }
      return true;
    } catch (e) {
      debugPrint('Error checking ML Kit models: $e');
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
        final isDownloaded = await _modelManager.isModelDownloaded(toModelTag(lang));

        if (!isDownloaded) {
          onProgress?.call(lang, i / requiredLanguages.length);
          final success = await _modelManager.downloadModel(toModelTag(lang));
          if (!success) {
            debugPrint('Failed to download ML Kit model for $lang');
            return false;
          }
        }
        onProgress?.call(lang, (i + 1) / requiredLanguages.length);
      }
      return true;
    } catch (e) {
      debugPrint('Error downloading ML Kit models: $e');
      return false;
    }
  }

  /// Performs digital ink recognition for a given [Ink]
  Future<List<RecognitionCandidate>> recognizeInk(
    Ink ink, {
    String languageCode = 'en',
  }) async {
    if (!isPlatformSupported) return [];

    DigitalInkRecognizer? recognizer;
    try {
      final tag = toModelTag(languageCode);
      if (!await _modelManager.isModelDownloaded(tag)) {
        await _modelManager.downloadModel(tag);
      }
      recognizer = DigitalInkRecognizer(languageCode: tag);
      final candidates = await recognizer.recognize(ink);
      return candidates;
    } catch (e) {
      debugPrint('Error recognizing digital ink: $e');
      return [];
    } finally {
      await recognizer?.close();
    }
  }

  /// Utility to check if any candidate matches the target word case-insensitively
  static bool isWordMatch(
    List<RecognitionCandidate> candidates,
    String targetWord,
  ) {
    if (candidates.isEmpty || targetWord.trim().isEmpty) return false;

    final cleanTarget = targetWord.trim().toLowerCase();

    for (final candidate in candidates) {
      final cleanText = candidate.text.trim().toLowerCase();
      if (cleanText == cleanTarget) {
        return true;
      }
    }
    return false;
  }
}
