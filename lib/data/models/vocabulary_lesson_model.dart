import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class VocabularyWordModel {
  const VocabularyWordModel({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
    this.partOfSpeech,
  });

  final String word;
  final String phonetic;
  final String meaning;
  final String example;
  final String? partOfSpeech;
}

class VocabularyLessonModel with LearningLessonItem {
  const VocabularyLessonModel({
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.wordsCompleted,
    required this.totalWords,
    required this.iconName,
    this.lessonId = '',
    this.words = const [],
  });

  final String lessonId;
  final int id;
  final int number;
  final String title;
  @override
  final LearningLessonStatus status;
  final int wordsCompleted;
  final int totalWords;
  @override
  final String iconName;
  final List<VocabularyWordModel> words;

  @override
  String get displayTitle => 'Lesson $number: $title';

  @override
  String localizedProgressLabel(AppLocalizations l10n) {
    if (status == LearningLessonStatus.locked) return l10n.locked;
    final done =
        status == LearningLessonStatus.notStarted ? 0 : wordsCompleted;
    return l10n.wordsProgress(done, totalWords, localizedStatusLabel(l10n));
  }

  @override
  String get progressLabel {
    return switch (status) {
      LearningLessonStatus.completed =>
        '$wordsCompleted/$totalWords words • Completed',
      LearningLessonStatus.inProgress =>
        '$wordsCompleted/$totalWords words • In progress',
      LearningLessonStatus.notStarted =>
        '0/$totalWords words • Not started',
      LearningLessonStatus.locked => 'Locked',
    };
  }

  @override
  double get progressValue {
    if (totalWords == 0) return 0;
    return wordsCompleted / totalWords;
  }
}
