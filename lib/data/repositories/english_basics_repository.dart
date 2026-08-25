import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';

class EnglishBasicsRepository {
  EnglishBasicsRepository(
    this._localStorage,
    this._progressRepository,
    this._dailyLessonRepository,
  );

  final LocalStorage _localStorage;
  final ProgressRepository _progressRepository;
  final DailyLessonRepository _dailyLessonRepository;

  static const _typeId = 'english_basics';
  static const _stepKey = 'english_basics_step_v1';

  final Map<String, EnglishBasicsTrackModel> _cache = {};

  Future<EnglishBasicsTrackModel> loadTrack(String goalId) async {
    if (_cache.containsKey(goalId)) return _cache[goalId]!;

    final raw = await rootBundle.loadString('assets/english_basics/$goalId.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final track = EnglishBasicsTrackModel(
      goalId: json['goalId'] as String,
      pathTitle: json['pathTitle'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList()
          .map(
            (lessonJson) => EnglishBasicsLessonModel.fromJson(
              json: lessonJson,
              status: LearningLessonStatus.locked,
            ),
          )
          .toList(),
    );
    _cache[goalId] = track;
    return track;
  }

  Future<List<EnglishBasicsLessonModel>> buildLessons(String goalId) async {
    await _progressRepository.initialize();
    await _dailyLessonRepository.initialize();

    final track = await loadTrack(goalId);
    final progress = _progressRepository.allProgress;
    final stepMap = _readStepMap();

    await _dailyLessonRepository.prepareForDayPath(
      typeId: _typeId,
      scopeId: goalId,
      progressCefrLevel: goalId,
      progressRepository: _progressRepository,
    );

    var lessons = track.lessons.map((lesson) {
      final saved = progress[lesson.lessonId];
      final status = saved?.status ??
          LessonUnlockLogic.statusForLesson(
            lessonNumber: lesson.number,
            progressByLessonId: progress,
            lessonId: lesson.lessonId,
            hasContent: true,
          );
      final stepIndex = stepMap['${goalId}_${lesson.lessonId}'] as int? ?? 0;
      return lesson.copyWith(
        status: status,
        currentStep: EnglishBasicsStep.fromIndex(stepIndex),
      );
    }).toList();

    lessons = _applySequentialUnlock(lessons, progress);

    final dailyState = _dailyLessonRepository.stateForPath(_typeId, goalId);
    return _dailyLessonRepository.applyGenericDailyGate(
      lessons,
      dailyState,
      lessonIdOf: (lesson) => lesson.lessonId,
      statusOf: (lesson) => lesson.status,
      withStatus: (lesson, status) => lesson.copyWith(status: status),
    );
  }

  EnglishBasicsLessonModel? activeLessonForGoal(String goalId) {
    final lessons = _cache[goalId]?.lessons;
    if (lessons == null) return null;
    for (final lesson in lessons) {
      if (lesson.status == LearningLessonStatus.inProgress ||
          lesson.status == LearningLessonStatus.notStarted) {
        return lesson;
      }
    }
    return null;
  }

  Future<EnglishBasicsLessonModel?> getTodaysLesson(String goalId) async {
    final lessons = await buildLessons(goalId);
    for (final lesson in lessons) {
      if (lesson.status == LearningLessonStatus.inProgress) return lesson;
    }
    for (final lesson in lessons) {
      if (lesson.status == LearningLessonStatus.notStarted) return lesson;
    }
    for (final lesson in lessons.reversed) {
      if (lesson.status == LearningLessonStatus.completed) return lesson;
    }
    return lessons.isNotEmpty ? lessons.first : null;
  }

  Future<double> trackProgress(String goalId) async {
    final lessons = await buildLessons(goalId);
    if (lessons.isEmpty) return 0;
    final completed =
        lessons.where((l) => l.status == LearningLessonStatus.completed).length;
    final inProgress = lessons.where(
      (l) => l.status == LearningLessonStatus.inProgress,
    );
    var progress = completed / lessons.length;
    if (inProgress.isNotEmpty) {
      progress += inProgress.first.flowProgress / lessons.length;
    }
    return progress.clamp(0.0, 1.0);
  }

  Future<void> recordLessonStarted({
    required String goalId,
    required String lessonId,
  }) async {
    await _dailyLessonRepository.recordLessonStartedPath(
      typeId: _typeId,
      scopeId: goalId,
      lessonId: lessonId,
    );
    await _progressRepository.saveInProgress(
      lessonId: lessonId,
      type: _typeId,
      cefrLevel: goalId,
      currentIndex: 0,
    );
  }

  Future<void> saveStep({
    required String goalId,
    required String lessonId,
    required EnglishBasicsStep step,
  }) async {
    final map = _readStepMap();
    map['${goalId}_$lessonId'] = step.stepIndex;
    await _localStorage.setString(_stepKey, jsonEncode(map));
    await _progressRepository.saveInProgress(
      lessonId: lessonId,
      type: _typeId,
      cefrLevel: goalId,
      currentIndex: step.stepIndex,
    );
  }

  Future<void> markLessonCompleted({
    required String goalId,
    required EnglishBasicsLessonModel lesson,
    required List<EnglishBasicsLessonModel> allLessons,
  }) async {
    final orderedIds = allLessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: lesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: lesson.lessonId,
      type: _typeId,
      cefrLevel: goalId,
      finalIndex: EnglishBasicsStep.complete.stepIndex,
    );

    await _dailyLessonRepository.recordLessonCompletedPath(
      typeId: _typeId,
      scopeId: goalId,
      completedLessonId: lesson.lessonId,
      nextUnlockLessonId: nextId,
    );

    final map = _readStepMap();
    map.remove('${goalId}_${lesson.lessonId}');
    await _localStorage.setString(_stepKey, jsonEncode(map));

    await _localStorage.incrementLessonsCompleted();
    await _localStorage.incrementWordsLearned(lesson.words.length);
    await _localStorage.incrementDailyProgress(5);
    await _localStorage.saveLessonProgress(await trackProgress(goalId));
  }

  List<EnglishBasicsLessonModel> _applySequentialUnlock(
    List<EnglishBasicsLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
  ) {
    if (lessons.isEmpty) return lessons;

    if (progress.isEmpty ||
        !progress.values.any((p) => p.type == _typeId)) {
      lessons[0] = lessons[0].copyWith(
        status: LearningLessonStatus.notStarted,
      );
    }

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (lesson.status != LearningLessonStatus.locked) continue;
      if (i == 0) {
        lessons[i] = lesson.copyWith(status: LearningLessonStatus.notStarted);
      } else if (lessons[i - 1].status == LearningLessonStatus.completed) {
        lessons[i] = lesson.copyWith(status: LearningLessonStatus.notStarted);
      }
    }
    return lessons;
  }

  Map<String, dynamic> _readStepMap() {
    final raw = _localStorage.getString(_stepKey);
    if (raw == null || raw.isEmpty) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
  }
}
