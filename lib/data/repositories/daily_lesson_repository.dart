import 'dart:convert';

import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';

class DailyLessonState {
  const DailyLessonState({
    required this.date,
    required this.type,
    required this.cefrLevel,
    this.activeLessonId,
    this.completedToday = false,
    this.pendingUnlockLessonId,
  });

  final String date;
  final String type;
  final String cefrLevel;
  final String? activeLessonId;
  final bool completedToday;
  final String? pendingUnlockLessonId;

  factory DailyLessonState.empty({
    required String type,
    required String cefrLevel,
    required String date,
  }) {
    return DailyLessonState(
      date: date,
      type: type,
      cefrLevel: cefrLevel,
    );
  }

  DailyLessonState copyWith({
    String? date,
    String? type,
    String? cefrLevel,
    String? activeLessonId,
    bool? completedToday,
    String? pendingUnlockLessonId,
    bool clearActiveLessonId = false,
    bool clearPendingUnlock = false,
  }) {
    return DailyLessonState(
      date: date ?? this.date,
      type: type ?? this.type,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      activeLessonId:
          clearActiveLessonId ? null : activeLessonId ?? this.activeLessonId,
      completedToday: completedToday ?? this.completedToday,
      pendingUnlockLessonId: clearPendingUnlock
          ? null
          : pendingUnlockLessonId ?? this.pendingUnlockLessonId,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'type': type,
        'cefrLevel': cefrLevel,
        if (activeLessonId != null) 'activeLessonId': activeLessonId,
        'completedToday': completedToday,
        if (pendingUnlockLessonId != null)
          'pendingUnlockLessonId': pendingUnlockLessonId,
      };

  factory DailyLessonState.fromJson(Map<String, dynamic> json) {
    return DailyLessonState(
      date: json['date'] as String,
      type: json['type'] as String,
      cefrLevel: json['cefrLevel'] as String,
      activeLessonId: json['activeLessonId'] as String?,
      completedToday: json['completedToday'] as bool? ?? false,
      pendingUnlockLessonId: json['pendingUnlockLessonId'] as String?,
    );
  }
}

class DailyLessonRepository {
  DailyLessonRepository(this._localStorage);

  final LocalStorage _localStorage;
  static const _storageKey = 'daily_lesson_v1';

  final Map<String, DailyLessonState> _states = {};
  bool _loaded = false;

  Future<void> initialize() async {
    if (_loaded) return;
    final raw = _localStorage.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in json.entries) {
        _states[entry.key] = DailyLessonState.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }
    _loaded = true;
  }

  DailyLessonState stateFor(LessonType type, String cefrLevel) {
    return stateForPath(type.id, cefrLevel);
  }

  DailyLessonState stateForPath(String typeId, String scopeId) {
    final key = _pathStateKey(typeId, scopeId);
    return _states[key] ??
        DailyLessonState.empty(
          type: typeId,
          cefrLevel: scopeId,
          date: _dateKey(DateTime.now()),
        );
  }

  Future<void> prepareForDay({
    required LessonType type,
    required String cefrLevel,
    required ProgressRepository progressRepository,
  }) {
    return prepareForDayPath(
      typeId: type.id,
      scopeId: cefrLevel,
      progressCefrLevel: cefrLevel,
      progressRepository: progressRepository,
    );
  }

  Future<void> prepareForDayPath({
    required String typeId,
    required String scopeId,
    required String progressCefrLevel,
    required ProgressRepository progressRepository,
  }) async {
    await initialize();
    final key = _pathStateKey(typeId, scopeId);
    final today = _dateKey(DateTime.now());
    var state = stateForPath(typeId, scopeId);

    if (state.date != today) {
      if (state.pendingUnlockLessonId != null) {
        await progressRepository.unlockLesson(
          lessonId: state.pendingUnlockLessonId!,
          type: typeId,
          cefrLevel: progressCefrLevel,
        );
      }
      state = DailyLessonState.empty(
        type: typeId,
        cefrLevel: scopeId,
        date: today,
      );
      _states[key] = state;
      await _persist();
    }
  }

  Future<void> recordLessonStarted({
    required LessonType type,
    required String cefrLevel,
    required String lessonId,
  }) {
    return recordLessonStartedPath(
      typeId: type.id,
      scopeId: cefrLevel,
      lessonId: lessonId,
    );
  }

  Future<void> recordLessonStartedPath({
    required String typeId,
    required String scopeId,
    required String lessonId,
  }) async {
    await initialize();
    final key = _pathStateKey(typeId, scopeId);
    final today = _dateKey(DateTime.now());
    var state = stateForPath(typeId, scopeId);

    if (state.date != today) {
      state = DailyLessonState.empty(
        type: typeId,
        cefrLevel: scopeId,
        date: today,
      );
    }
    if (state.completedToday || state.activeLessonId != null) return;

    _states[key] = state.copyWith(activeLessonId: lessonId);
    await _persist();
  }

  Future<void> recordLessonCompleted({
    required LessonType type,
    required String cefrLevel,
    required String completedLessonId,
    String? nextUnlockLessonId,
  }) {
    return recordLessonCompletedPath(
      typeId: type.id,
      scopeId: cefrLevel,
      completedLessonId: completedLessonId,
      nextUnlockLessonId: nextUnlockLessonId,
    );
  }

  Future<void> recordLessonCompletedPath({
    required String typeId,
    required String scopeId,
    required String completedLessonId,
    String? nextUnlockLessonId,
  }) async {
    await initialize();
    final key = _pathStateKey(typeId, scopeId);
    final today = _dateKey(DateTime.now());
    var state = stateForPath(typeId, scopeId);

    if (state.date != today) {
      state = DailyLessonState.empty(
        type: typeId,
        cefrLevel: scopeId,
        date: today,
      );
    }

    _states[key] = state.copyWith(
      completedToday: true,
      clearActiveLessonId: true,
      pendingUnlockLessonId: nextUnlockLessonId,
    );
    await _persist();
  }

  String? allowedNotStartedLessonId<T>(
    List<T> lessons,
    DailyLessonState state, {
    required String Function(T lesson) lessonIdOf,
    required LearningLessonStatus Function(T lesson) statusOf,
  }) {
    if (state.completedToday) return null;

    for (final lesson in lessons) {
      if (statusOf(lesson) == LearningLessonStatus.inProgress) {
        return lessonIdOf(lesson);
      }
    }

    if (state.activeLessonId != null) return state.activeLessonId;

    for (final lesson in lessons) {
      if (statusOf(lesson) == LearningLessonStatus.notStarted) {
        return lessonIdOf(lesson);
      }
    }
    return null;
  }

  List<VocabularyLessonModel> applyVocabularyDailyGate(
    List<VocabularyLessonModel> lessons,
    DailyLessonState state,
  ) {
    final allowedId = allowedNotStartedLessonId(
      lessons,
      state,
      lessonIdOf: (lesson) => lesson.lessonId,
      statusOf: (lesson) => lesson.status,
    );
    return lessons
        .map(
          (lesson) => lesson.status == LearningLessonStatus.notStarted &&
                  lesson.lessonId != allowedId
              ? _vocabularyWithStatus(lesson, LearningLessonStatus.locked)
              : lesson,
        )
        .toList();
  }

  List<GrammarLessonModel> applyGrammarDailyGate(
    List<GrammarLessonModel> lessons,
    DailyLessonState state,
  ) {
    final allowedId = allowedNotStartedLessonId(
      lessons,
      state,
      lessonIdOf: (lesson) => lesson.lessonId,
      statusOf: (lesson) => lesson.status,
    );
    return lessons
        .map(
          (lesson) => lesson.status == LearningLessonStatus.notStarted &&
                  lesson.lessonId != allowedId
              ? _grammarWithStatus(lesson, LearningLessonStatus.locked)
              : lesson,
        )
        .toList();
  }

  List<ReadingLessonModel> applyReadingDailyGate(
    List<ReadingLessonModel> lessons,
    DailyLessonState state,
  ) {
    final allowedId = allowedNotStartedLessonId(
      lessons,
      state,
      lessonIdOf: (lesson) => lesson.lessonId,
      statusOf: (lesson) => lesson.status,
    );
    return lessons
        .map(
          (lesson) => lesson.status == LearningLessonStatus.notStarted &&
                  lesson.lessonId != allowedId
              ? _readingWithStatus(lesson, LearningLessonStatus.locked)
              : lesson,
        )
        .toList();
  }

  List<T> applyGenericDailyGate<T>(
    List<T> lessons,
    DailyLessonState state, {
    required String Function(T lesson) lessonIdOf,
    required LearningLessonStatus Function(T lesson) statusOf,
    required T Function(T lesson, LearningLessonStatus status) withStatus,
  }) {
    final allowedId = allowedNotStartedLessonId(
      lessons,
      state,
      lessonIdOf: lessonIdOf,
      statusOf: statusOf,
    );
    return lessons
        .map(
          (lesson) => statusOf(lesson) == LearningLessonStatus.notStarted &&
                  lessonIdOf(lesson) != allowedId
              ? withStatus(lesson, LearningLessonStatus.locked)
              : lesson,
        )
        .toList();
  }

  String _pathStateKey(String typeId, String scopeId) => '${typeId}_$scopeId';

  String _dateKey(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  Future<void> _persist() async {
    final json = _states.map((key, value) => MapEntry(key, value.toJson()));
    await _localStorage.setString(_storageKey, jsonEncode(json));
  }

  VocabularyLessonModel _vocabularyWithStatus(
    VocabularyLessonModel lesson,
    LearningLessonStatus status,
  ) {
    return VocabularyLessonModel(
      lessonId: lesson.lessonId,
      id: lesson.id,
      number: lesson.number,
      title: lesson.title,
      status: status,
      wordsCompleted: lesson.wordsCompleted,
      totalWords: lesson.totalWords,
      iconName: lesson.iconName,
      words: lesson.words,
    );
  }

  GrammarLessonModel _grammarWithStatus(
    GrammarLessonModel lesson,
    LearningLessonStatus status,
  ) {
    return GrammarLessonModel(
      lessonId: lesson.lessonId,
      id: lesson.id,
      number: lesson.number,
      title: lesson.title,
      status: status,
      stepsCompleted: lesson.stepsCompleted,
      totalSteps: lesson.totalSteps,
      iconName: lesson.iconName,
      useLessonPrefix: lesson.useLessonPrefix,
      steps: lesson.steps,
      completionTitle: lesson.completionTitle,
      completionSummary: lesson.completionSummary,
    );
  }

  ReadingLessonModel _readingWithStatus(
    ReadingLessonModel lesson,
    LearningLessonStatus status,
  ) {
    return ReadingLessonModel(
      lessonId: lesson.lessonId,
      id: lesson.id,
      number: lesson.number,
      title: lesson.title,
      status: status,
      phasesCompleted: lesson.phasesCompleted,
      totalPhases: lesson.totalPhases,
      iconName: lesson.iconName,
      useLessonPrefix: lesson.useLessonPrefix,
      phases: lesson.phases,
      questions: lesson.questions,
      completionTitle: lesson.completionTitle,
      completionSummary: lesson.completionSummary,
    );
  }
}
