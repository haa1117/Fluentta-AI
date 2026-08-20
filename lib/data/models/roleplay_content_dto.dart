import 'package:fluentta_ai/data/models/lesson_content_dto.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';

class RoleplayScenarioManifestDto {
  const RoleplayScenarioManifestDto({
    required this.id,
    required this.cefrLevel,
    required this.vocabularyAsset,
    required this.quickCheckAsset,
  });

  final String id;
  final String cefrLevel;
  final String vocabularyAsset;
  final String quickCheckAsset;

  factory RoleplayScenarioManifestDto.fromJson(Map<String, dynamic> json) {
    return RoleplayScenarioManifestDto(
      id: json['id'] as String,
      cefrLevel: json['cefrLevel'] as String? ?? 'A1',
      vocabularyAsset: json['vocabularyAsset'] as String,
      quickCheckAsset: json['quickCheckAsset'] as String,
    );
  }
}

class RoleplayPathDto {
  const RoleplayPathDto({
    required this.scenarioId,
    required this.cefrLevel,
    required this.pathTitle,
    required this.pathSubtitle,
    required this.lessons,
  });

  final String scenarioId;
  final String cefrLevel;
  final String pathTitle;
  final String pathSubtitle;
  final List<Map<String, dynamic>> lessons;

  factory RoleplayPathDto.fromJson(Map<String, dynamic> json) {
    return RoleplayPathDto(
      scenarioId: json['scenarioId'] as String,
      cefrLevel: json['cefrLevel'] as String? ?? 'A1',
      pathTitle: json['pathTitle'] as String,
      pathSubtitle: json['pathSubtitle'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'scenarioId': scenarioId,
        'cefrLevel': cefrLevel,
        'pathTitle': pathTitle,
        'pathSubtitle': pathSubtitle,
        'lessons': lessons,
      };
}

class RoleplayQuickCheckLessonModel implements LearningLessonItem {
  const RoleplayQuickCheckLessonModel({
    required this.lessonId,
    required this.id,
    required this.number,
    required this.title,
    required this.status,
    required this.questionsCompleted,
    required this.totalQuestions,
    required this.iconName,
    required this.questions,
    this.feedbacks = const [],
    this.completionTitle,
    this.completionSummary,
  });

  final String lessonId;
  final int id;
  final int number;
  final String title;
  @override
  final LearningLessonStatus status;
  final int questionsCompleted;
  final int totalQuestions;
  @override
  final String iconName;
  final List<ReadingQuestionModel> questions;
  final List<String?> feedbacks;
  final String? completionTitle;
  final String? completionSummary;

  @override
  String get displayTitle => 'Lesson $number: $title';

  @override
  String get progressLabel {
    return switch (status) {
      LearningLessonStatus.completed =>
        '$questionsCompleted/$totalQuestions questions • Completed',
      LearningLessonStatus.inProgress =>
        '$questionsCompleted/$totalQuestions questions • In progress',
      LearningLessonStatus.notStarted =>
        '0/$totalQuestions questions • Not started',
      LearningLessonStatus.locked => 'Locked',
    };
  }

  @override
  double get progressValue {
    if (totalQuestions == 0) return 0;
    return questionsCompleted / totalQuestions;
  }

  RoleplayQuickCheckLessonModel copyWith({
    LearningLessonStatus? status,
    int? questionsCompleted,
  }) {
    return RoleplayQuickCheckLessonModel(
      lessonId: lessonId,
      id: id,
      number: number,
      title: title,
      status: status ?? this.status,
      questionsCompleted: questionsCompleted ?? this.questionsCompleted,
      totalQuestions: totalQuestions,
      iconName: iconName,
      questions: questions,
      completionTitle: completionTitle,
      completionSummary: completionSummary,
    );
  }

  static RoleplayQuickCheckLessonModel fromLessonJson({
    required Map<String, dynamic> json,
    required LearningLessonStatus status,
    required int questionsCompleted,
  }) {
    final questions = (json['questions'] as List<dynamic>)
        .map(
          (e) => ReadingQuestionDto.fromJson(e as Map<String, dynamic>).toModel(),
        )
        .toList();
    final questionDtos = (json['questions'] as List<dynamic>)
        .map((e) => ReadingQuestionDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return RoleplayQuickCheckLessonModel(
      lessonId: json['id'] as String,
      id: json['number'] as int,
      number: json['number'] as int,
      title: json['title'] as String,
      status: status,
      questionsCompleted: questionsCompleted,
      totalQuestions: questions.length,
      iconName: json['iconName'] as String? ?? 'chat',
      questions: questions,
      feedbacks: questionDtos.map((q) => q.feedback).toList(),
      completionTitle: json['completionTitle'] as String?,
      completionSummary: json['completionSummary'] as String?,
    );
  }
}

extension RoleplayVocabularyPathParsing on RoleplayPathDto {
  List<VocabularyLessonModel> toVocabularyLessons({
    required Map<String, LearningLessonStatus> statusById,
    required Map<String, int> indexById,
  }) {
    return lessons.map((lessonJson) {
      final dto = VocabularyLessonContentDto.fromJson(lessonJson);
      final status = statusById[dto.id] ?? LearningLessonStatus.locked;
      final savedIndex = indexById[dto.id] ?? 0;
      final wordsCompleted = status == LearningLessonStatus.completed
          ? dto.words.length
          : savedIndex;
      return dto.toLessonModel(
        status: status,
        wordsCompleted: wordsCompleted.clamp(0, dto.words.length),
      );
    }).toList();
  }
}
