import 'package:fluentta_ai/l10n/app_localizations.dart';

enum LearningLessonStatus {
  completed,
  inProgress,
  notStarted,
  locked,
}

/// Shared contract for lesson list tiles used by Vocabulary and Grammar.
mixin LearningLessonItem {
  LearningLessonStatus get status;
  int get number;
  String get title;
  String get displayTitle;
  String get progressLabel;
  double get progressValue;
  String get iconName;
  bool get useLessonPrefix => true;

  String localizedDisplayTitle(AppLocalizations l10n) {
    return useLessonPrefix ? l10n.lessonNamedTitle(number, title) : title;
  }

  String localizedStatusLabel(AppLocalizations l10n) {
    return switch (status) {
      LearningLessonStatus.completed => l10n.completed,
      LearningLessonStatus.inProgress => l10n.inProgress,
      LearningLessonStatus.notStarted => l10n.notStarted,
      LearningLessonStatus.locked => l10n.locked,
    };
  }

  String localizedProgressLabel(AppLocalizations l10n) {
    return switch (status) {
      LearningLessonStatus.completed => l10n.completed,
      LearningLessonStatus.inProgress => l10n.inProgress,
      LearningLessonStatus.notStarted => '',
      LearningLessonStatus.locked => l10n.locked,
    };
  }
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
