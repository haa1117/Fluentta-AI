import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

class GrammarExampleModel {
  const GrammarExampleModel({
    required this.prefix,
    required this.highlight,
    required this.suffix,
    this.iconName = 'person',
  });

  final String prefix;
  final String highlight;
  final String suffix;
  final String iconName;

}

class GrammarStepModel {
  const GrammarStepModel({
    required this.title,
    required this.description,
    required this.formula,
    required this.examples,
    required this.quickTip,
  });

  final String title;
  final String description;
  final String formula;
  final List<GrammarExampleModel> examples;
  final String quickTip;
}

class GrammarLessonModel implements LearningLessonItem {
  const GrammarLessonModel({
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.stepsCompleted,
    required this.totalSteps,
    required this.iconName,
    this.useLessonPrefix = true,
    this.steps = const [],
    this.completionTitle,
    this.completionSummary,
  });

  final int id;
  final int number;
  final String title;
  @override
  final LearningLessonStatus status;
  final int stepsCompleted;
  final int totalSteps;
  @override
  final String iconName;
  final bool useLessonPrefix;
  final List<GrammarStepModel> steps;
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
    if (totalSteps == 0) return 0;
    return stepsCompleted / totalSteps;
  }
}
