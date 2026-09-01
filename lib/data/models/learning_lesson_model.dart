enum LearningLessonStatus {
  completed,
  inProgress,
  notStarted,
  locked,
}

/// Shared contract for lesson list tiles used by Vocabulary and Grammar.
abstract class LearningLessonItem {
  LearningLessonStatus get status;
  String get displayTitle;
  String get progressLabel;
  double get progressValue;
  String get iconName;
}

class LearningPathData {
  const LearningPathData({
    required this.title,
    required this.subtitle,
    required this.completedLessons,
    required this.totalLessons,
  });

  final String title;
  final String subtitle;
  final int completedLessons;
  final int totalLessons;

  double get progress =>
      totalLessons == 0 ? 0 : completedLessons / totalLessons;

  int get progressPercent => (progress * 100).round();
}
