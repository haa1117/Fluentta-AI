import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

class ReadingDialogueLineModel {
  const ReadingDialogueLineModel({
    required this.speakerLabel,
    required this.text,
    required this.isUser,
  });

  final String speakerLabel;
  final String text;
  final bool isUser;
}

class ReadingQuestionModel {
  const ReadingQuestionModel({
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
}

class ReadingPhaseModel {
  const ReadingPhaseModel({
    required this.phaseTitle,
    required this.lines,
    required this.tip,
    this.question,
    this.dialoguePartNumber,
    this.isTextPassage = false,
  });

  final String phaseTitle;
  final List<ReadingDialogueLineModel> lines;
  final String tip;
  final ReadingQuestionModel? question;
  final int? dialoguePartNumber;
  final bool isTextPassage;

  bool get isQuestionPhase => question != null;
  bool get isDialoguePhase => !isQuestionPhase && !isTextPassage;
}

class ReadingLessonModel implements LearningLessonItem {
  const ReadingLessonModel({
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.phasesCompleted,
    required this.totalPhases,
    required this.iconName,
    this.lessonId = '',
    this.useLessonPrefix = true,
    this.phases = const [],
    this.questions = const [],
    this.completionTitle,
    this.completionSummary,
  });

  final String lessonId;
  final int id;
  final int number;
  final String title;
  @override
  final LearningLessonStatus status;
  final int phasesCompleted;
  final int totalPhases;
  @override
  final String iconName;
  final bool useLessonPrefix;
  final List<ReadingPhaseModel> phases;
  final List<ReadingQuestionModel> questions;
  final String? completionTitle;
  final String? completionSummary;

  @override
  String get displayTitle =>
      useLessonPrefix ? 'Lesson $number: $title' : title;

  @override
  String get progressLabel {
    return switch (status) {
      LearningLessonStatus.completed => 'Completed',
      LearningLessonStatus.inProgress => 'In progress',
      LearningLessonStatus.notStarted => '',
      LearningLessonStatus.locked => 'Locked',
    };
  }

  @override
  double get progressValue {
    if (totalPhases == 0) return 0;
    return phasesCompleted / totalPhases;
  }
}
