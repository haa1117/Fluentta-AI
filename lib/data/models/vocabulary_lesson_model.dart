class VocabularyWordModel {
  const VocabularyWordModel({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
  });

  final String word;
  final String phonetic;
  final String meaning;
  final String example;
}

enum VocabularyLessonStatus {
  completed,
  inProgress,
  notStarted,
  locked,
}

class VocabularyLessonModel {
  const VocabularyLessonModel({
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.wordsCompleted,
    required this.totalWords,
    required this.iconName,
    this.words = const [],
  });

  final int id;
  final int number;
  final String title;
  final VocabularyLessonStatus status;
  final int wordsCompleted;
  final int totalWords;
  final String iconName;
  final List<VocabularyWordModel> words;

  String get progressLabel {
    return switch (status) {
      VocabularyLessonStatus.completed => '$wordsCompleted/$totalWords words • Completed',
      VocabularyLessonStatus.inProgress => '$wordsCompleted/$totalWords words • In progress',
      VocabularyLessonStatus.notStarted => '0/$totalWords words • Not started',
      VocabularyLessonStatus.locked => 'Locked',
    };
  }

  double get progressValue {
    if (totalWords == 0) return 0;
    return wordsCompleted / totalWords;
  }
}
