import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/english_basics_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';

class EnglishBasicsFlowViewModel extends ChangeNotifier {
  EnglishBasicsFlowViewModel({
    required this.goalId,
    required this.lesson,
    required this.repository,
    required this.allLessons,
    required this.textToSpeechService,
    required this.progressSyncService,
    required this.onFinished,
    this.onStatsUpdated,
  }) : _step = _initialStep(lesson);

  static EnglishBasicsStep _initialStep(EnglishBasicsLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.inProgress &&
        lesson.currentStep.stepIndex > 0) {
      return lesson.currentStep;
    }
    return EnglishBasicsStep.intro;
  }

  final String goalId;
  final EnglishBasicsLessonModel lesson;
  final EnglishBasicsRepository repository;
  final List<EnglishBasicsLessonModel> allLessons;
  final TextToSpeechService textToSpeechService;
  final ProgressSyncService progressSyncService;
  final VoidCallback onFinished;
  final Future<void> Function()? onStatsUpdated;

  EnglishBasicsStep _step;
  final Map<int, int?> _sentenceSelections = {};
  final Map<int, bool> _sentenceAnswered = {};

  EnglishBasicsStep get step => _step;

  double get progress => _step.stepIndex / 4;

  String get stepLabel => switch (_step) {
        EnglishBasicsStep.words => '1 / ${lesson.wordsStepLabel.toUpperCase()}',
        EnglishBasicsStep.sentences =>
          '2 / ${lesson.sentencesStepLabel.toUpperCase()}',
        EnglishBasicsStep.dialogue =>
          '3 / ${lesson.dialogueStepLabel.toUpperCase()}',
        _ => '',
      };

  bool get canContinueFromSentences {
    if (_step != EnglishBasicsStep.sentences) return false;
    if (lesson.questions.isEmpty) return true;
    for (var i = 0; i < lesson.questions.length; i++) {
      if (_sentenceSelections[i] == null) return false;
    }
    return true;
  }

  int? selectionForQuestion(int index) => _sentenceSelections[index];

  bool isQuestionAnswered(int index) => _sentenceAnswered[index] ?? false;

  bool isSelectionCorrect(int questionIndex, int optionIndex) {
    return lesson.questions[questionIndex].correctIndex == optionIndex;
  }

  Future<void> persistStep() async {
    await repository.saveStep(
      goalId: goalId,
      lessonId: lesson.lessonId,
      step: _step,
    );
  }

  Future<void> startLesson() async {
    _step = EnglishBasicsStep.words;
    await persistStep();
    notifyListeners();
  }

  Future<void> goToSentences() async {
    _step = EnglishBasicsStep.sentences;
    await persistStep();
    notifyListeners();
  }

  Future<void> goToDialogue() async {
    _step = EnglishBasicsStep.dialogue;
    await persistStep();
    notifyListeners();
  }

  Future<void> completeLesson() async {
    _step = EnglishBasicsStep.complete;
    notifyListeners();
    await repository.markLessonCompleted(
      goalId: goalId,
      lesson: lesson,
      allLessons: allLessons,
    );
    await onStatsUpdated?.call();
    onFinished();
  }

  void selectSentenceOption(int questionIndex, int optionIndex) {
    if (_sentenceAnswered[questionIndex] == true) return;
    _sentenceSelections[questionIndex] = optionIndex;
    _sentenceAnswered[questionIndex] = true;
    if (!isSelectionCorrect(questionIndex, optionIndex)) {
      HapticFeedback.heavyImpact();
      unawaited(progressSyncService.recordCorrections(1));
    }
    notifyListeners();
  }

  Future<void> speak(String text) => textToSpeechService.speak(text);
}
