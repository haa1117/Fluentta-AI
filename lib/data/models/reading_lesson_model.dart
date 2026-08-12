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

class ReadingPhaseModel {
  const ReadingPhaseModel({
    required this.phaseTitle,
    required this.lines,
    required this.tip,
  });

  final String phaseTitle;
  final List<ReadingDialogueLineModel> lines;
  final String tip;
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
    this.useLessonPrefix = true,
    this.phases = const [],
    this.completionTitle,
    this.completionSummary,
  });

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
