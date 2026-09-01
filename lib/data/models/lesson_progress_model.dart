import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

class LessonProgressModel {
  const LessonProgressModel({
    required this.lessonId,
    required this.type,
    required this.cefrLevel,
    required this.status,
    required this.currentIndex,
    required this.updatedAt,
    this.completedAt,
  });

  final String lessonId;
  final String type;
  final String cefrLevel;
  final LearningLessonStatus status;
  final int currentIndex;
  final DateTime updatedAt;
  final DateTime? completedAt;

  factory LessonProgressModel.initial({
    required String lessonId,
    required String type,
    required String cefrLevel,
  }) {
    return LessonProgressModel(
      lessonId: lessonId,
      type: type,
      cefrLevel: cefrLevel,
      status: LearningLessonStatus.notStarted,
      currentIndex: 0,
      updatedAt: DateTime.now(),
    );
  }

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lessonId'] as String,
      type: json['type'] as String,
      cefrLevel: json['cefrLevel'] as String,
      status: _statusFromString(json['status'] as String?),
      currentIndex: json['currentIndex'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  factory LessonProgressModel.fromFirestore(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lessonId'] as String,
      type: json['type'] as String,
      cefrLevel: json['cefrLevel'] as String,
      status: _statusFromString(json['status'] as String?),
      currentIndex: json['currentIndex'] as int? ?? 0,
      updatedAt: _parseDate(json['updatedAt']),
      completedAt: json['completedAt'] != null
          ? _parseDate(json['completedAt'])
          : null,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }

  static LearningLessonStatus _statusFromString(String? value) {
    return switch (value) {
      'completed' => LearningLessonStatus.completed,
      'inProgress' => LearningLessonStatus.inProgress,
      'notStarted' => LearningLessonStatus.notStarted,
      _ => LearningLessonStatus.locked,
    };
  }

  static String _statusToString(LearningLessonStatus status) {
    return switch (status) {
      LearningLessonStatus.completed => 'completed',
      LearningLessonStatus.inProgress => 'inProgress',
      LearningLessonStatus.notStarted => 'notStarted',
      LearningLessonStatus.locked => 'locked',
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'lessonId': lessonId,
      'type': type,
      'cefrLevel': cefrLevel,
      'status': _statusToString(status),
      'currentIndex': currentIndex,
      'updatedAt': updatedAt.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'type': type,
      'cefrLevel': cefrLevel,
      'status': _statusToString(status),
      'currentIndex': currentIndex,
      'updatedAt': updatedAt.toIso8601String(),
      if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    };
  }

  LessonProgressModel copyWith({
    LearningLessonStatus? status,
    int? currentIndex,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return LessonProgressModel(
      lessonId: lessonId,
      type: type,
      cefrLevel: cefrLevel,
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool isNewerThan(LessonProgressModel other) {
    return updatedAt.isAfter(other.updatedAt);
  }
}
