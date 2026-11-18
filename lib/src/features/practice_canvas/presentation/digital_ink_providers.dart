import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/digital_ink_service.dart';

final digitalInkServiceProvider = Provider<DigitalInkRecognitionService>((ref) {
  return DigitalInkRecognitionService();
});

enum ModelInitStatus {
  initial,
  checking,
  downloading,
  ready,
  error,
}

class ModelInitState {
  final ModelInitStatus status;
  final String currentLanguage;
  final double progress;
  final String? errorMessage;

  const ModelInitState({
    this.status = ModelInitStatus.initial,
    this.currentLanguage = '',
    this.progress = 0.0,
    this.errorMessage,
  });

  ModelInitState copyWith({
    ModelInitStatus? status,
    String? currentLanguage,
    double? progress,
    String? errorMessage,
  }) {
    return ModelInitState(
      status: status ?? this.status,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DigitalInkModelNotifier extends StateNotifier<ModelInitState> {
  final DigitalInkRecognitionService _service;

  DigitalInkModelNotifier(this._service)
      : super(
          _service.isPlatformSupported
              ? const ModelInitState()
              : const ModelInitState(
                  status: ModelInitStatus.ready,
                  progress: 1.0,
                ),
        ) {
    if (_service.isPlatformSupported) {
      initializeModels();
    }
  }

  Future<void> initializeModels() async {
    if (!_service.isPlatformSupported) {
      state = state.copyWith(
        status: ModelInitStatus.ready,
        progress: 1.0,
      );
      return;
    }

    state = state.copyWith(status: ModelInitStatus.checking);

    final alreadyDownloaded = await _service.areModelsDownloaded();
    if (alreadyDownloaded) {
      state = state.copyWith(
        status: ModelInitStatus.ready,
        progress: 1.0,
      );
      return;
    }

    state = state.copyWith(
      status: ModelInitStatus.downloading,
      progress: 0.1,
    );

    final success = await _service.downloadRequiredModels(
      onProgress: (lang, progress) {
        state = state.copyWith(
          currentLanguage: lang,
          progress: progress,
        );
      },
    );

    if (success) {
      state = state.copyWith(
        status: ModelInitStatus.ready,
        progress: 1.0,
      );
    } else {
      state = state.copyWith(
        status: ModelInitStatus.error,
        errorMessage: 'Échec du téléchargement des modèles de langue.',
      );
    }
  }
}

final digitalInkModelNotifierProvider =
    StateNotifierProvider<DigitalInkModelNotifier, ModelInitState>((ref) {
  final service = ref.watch(digitalInkServiceProvider);
  return DigitalInkModelNotifier(service);
});
