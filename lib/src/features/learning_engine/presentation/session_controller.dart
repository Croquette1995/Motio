import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_providers.dart';
import '../../settings/application/user_level_controller.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import '../domain/study_session.dart';

enum PracticeMode {
  canvas('Écriture manuscrite'),
  cloze('Phrases à trous'),
  matching('Association');

  final String label;
  const PracticeMode(this.label);
}

class SessionState {
  final StudySession? studySession;
  final bool isLoading;
  final PracticeMode currentMode;
  final bool isFinished;
  final int correctAnswers;
  final int failedAnswers;

  const SessionState({
    this.studySession,
    this.isLoading = false,
    this.currentMode = PracticeMode.canvas,
    this.isFinished = false,
    this.correctAnswers = 0,
    this.failedAnswers = 0,
  });

  SessionCard? get currentCard => studySession?.currentCard;
  int get remainingCards => studySession?.remainingCount ?? 0;
  int get completedCards => studySession?.completedCount ?? 0;
  double get progressRatio => studySession?.progressRatio ?? 0.0;

  SessionState copyWith({
    StudySession? studySession,
    bool? isLoading,
    PracticeMode? currentMode,
    bool? isFinished,
    int? correctAnswers,
    int? failedAnswers,
  }) {
    return SessionState(
      studySession: studySession ?? this.studySession,
      isLoading: isLoading ?? this.isLoading,
      currentMode: currentMode ?? this.currentMode,
      isFinished: isFinished ?? this.isFinished,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      failedAnswers: failedAnswers ?? this.failedAnswers,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    return const SessionState();
  }

  Future<void> startSession({int maxCards = 20, int maxNewCards = 5, String? overrideLevel}) async {
    state = state.copyWith(isLoading: true, isFinished: false);

    final currentLevel = ref.read(userLevelProvider);
    final scheduler = ref.read(sessionSchedulerServiceProvider);
    final session = await scheduler.createSession(
      maxSessionCards: maxCards,
      maxNewCards: maxNewCards,
      targetLevel: overrideLevel ?? currentLevel.code,
    );

    state = SessionState(
      studySession: session,
      isLoading: false,
      currentMode: state.currentMode,
      isFinished: session.isCompleted,
    );
  }

  Future<void> submitAnswer(bool isSuccess) async {
    final session = state.studySession;
    if (session == null || session.isCompleted) return;

    final srs = ref.read(srsServiceProvider);
    await srs.submitAnswer(session: session, isSuccess: isSuccess);

    ref.invalidate(wordProgressMapProvider);

    state = state.copyWith(
      studySession: session,
      correctAnswers: isSuccess ? state.correctAnswers + 1 : state.correctAnswers,
      failedAnswers: !isSuccess ? state.failedAnswers + 1 : state.failedAnswers,
      isFinished: session.isCompleted,
    );
  }

  void switchMode(PracticeMode mode) {
    state = state.copyWith(currentMode: mode);
  }
}

final sessionControllerProvider =
    NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);
