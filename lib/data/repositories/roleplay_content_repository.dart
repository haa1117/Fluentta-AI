import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_sync_repository.dart';

class RoleplayContentRepository {
  RoleplayContentRepository(
    this._localStorage,
    this._syncRepository,
  );

  final LocalStorage _localStorage;
  final RoleplayContentSyncRepository _syncRepository;

  static const _cacheKey = 'roleplay_content_cache_v1';

  List<RoleplayScenarioManifestDto>? _manifest;
  final Map<String, dynamic> _bundleCache = {};
  final Map<String, RoleplayPathDto> _pathCache = {};

  Future<void> initialize() async {
    if (_manifest != null) return;
    final raw = await rootBundle.loadString('assets/roleplay/manifest.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _manifest = (json['scenarios'] as List<dynamic>)
        .map(
          (e) => RoleplayScenarioManifestDto.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<RoleplayScenarioManifestDto>> getScenarios() async {
    await initialize();
    return List.unmodifiable(_manifest!);
  }

  Future<RoleplayScenarioManifestDto?> scenarioById(String id) async {
    await initialize();
    for (final scenario in _manifest!) {
      if (scenario.id == id) return scenario;
    }
    return null;
  }

  Future<RoleplayPathDto> getVocabularyPath(String scenarioId) {
    return _loadPath(
      scenarioId: scenarioId,
      practiceKey: 'vocabulary',
      assetPathResolver: (manifest) => manifest.vocabularyAsset,
    );
  }

  Future<RoleplayPathDto> getQuickCheckPath(String scenarioId) {
    return _loadPath(
      scenarioId: scenarioId,
      practiceKey: 'quick_check',
      assetPathResolver: (manifest) => manifest.quickCheckAsset,
    );
  }

  Future<RoleplayPathDto> _loadPath({
    required String scenarioId,
    required String practiceKey,
    required String Function(RoleplayScenarioManifestDto manifest) assetPathResolver,
  }) async {
    final cacheKey = '${scenarioId}_$practiceKey';
    if (_pathCache.containsKey(cacheKey)) {
      return _pathCache[cacheKey]!;
    }

    final manifest = await scenarioById(scenarioId);
    if (manifest == null) {
      throw StateError('Unknown roleplay scenario: $scenarioId');
    }

    Map<String, dynamic>? json;

    json = _readCachedPath(cacheKey);
    json ??= await _syncRepository.fetchPath(
      scenarioId: scenarioId,
      practiceKey: practiceKey,
    );
    if (json != null) {
      await _writeCachedPath(cacheKey, json);
    }

    json ??= await _loadBundledJson(assetPathResolver(manifest));
    final path = RoleplayPathDto.fromJson(json);
    _pathCache[cacheKey] = path;
    return path;
  }

  Future<Map<String, dynamic>> _loadBundledJson(String assetPath) async {
    if (_bundleCache.containsKey(assetPath)) {
      return _bundleCache[assetPath] as Map<String, dynamic>;
    }
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    _bundleCache[assetPath] = json;
    return json;
  }

  Map<String, dynamic>? _readCachedPath(String cacheKey) {
    final raw = _localStorage.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final entry = json[cacheKey];
    if (entry is Map<String, dynamic>) return entry;
    return null;
  }

  Future<void> _writeCachedPath(String cacheKey, Map<String, dynamic> data) async {
    final raw = _localStorage.getString(_cacheKey);
    final json = raw == null || raw.isEmpty
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(raw) as Map<String, dynamic>);
    json[cacheKey] = data;
    await _localStorage.setString(_cacheKey, jsonEncode(json));
  }

  Future<List<VocabularyLessonModel>> buildVocabularyLessons({
    required String scenarioId,
    required ProgressRepository progressRepository,
  }) async {
    final path = await getVocabularyPath(scenarioId);
    await progressRepository.initialize();
    final progress = progressRepository.allProgress;
    final lessons = path.toVocabularyLessons(
      statusById: {
        for (final entry in progress.entries)
          if (entry.value.type == RoleplayPracticeType.vocabulary.id)
            entry.key: entry.value.status,
      },
      indexById: {
        for (final entry in progress.entries)
          if (entry.value.type == RoleplayPracticeType.vocabulary.id)
            entry.key: entry.value.currentIndex,
      },
    );
    return _applySequentialUnlock(lessons, progress);
  }

  Future<List<RoleplayQuickCheckLessonModel>> buildQuickCheckLessons({
    required String scenarioId,
    required ProgressRepository progressRepository,
  }) async {
    final path = await getQuickCheckPath(scenarioId);
    await progressRepository.initialize();
    final progress = progressRepository.allProgress;

    final lessons = path.lessons.map((lessonJson) {
      final lessonId = lessonJson['id'] as String;
      final saved = progress[lessonId];
      final status = saved?.status ??
          LessonUnlockLogic.statusForLesson(
            lessonNumber: lessonJson['number'] as int,
            progressByLessonId: progress,
            lessonId: lessonId,
            hasContent: (lessonJson['questions'] as List).isNotEmpty,
          );
      final questionsCompleted = saved?.status == LearningLessonStatus.completed
          ? (lessonJson['questions'] as List).length
          : saved?.currentIndex ?? 0;

      return RoleplayQuickCheckLessonModel.fromLessonJson(
        json: lessonJson,
        status: status,
        questionsCompleted: questionsCompleted,
      );
    }).toList();

    return _applyQuickCheckUnlock(lessons, progress);
  }

  List<VocabularyLessonModel> _applySequentialUnlock(
    List<VocabularyLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
  ) {
    if (lessons.isEmpty) return lessons;

    if (progress.isEmpty ||
        !progress.values.any(
          (p) => p.type == RoleplayPracticeType.vocabulary.id,
        )) {
      if (lessons.first.words.isNotEmpty) {
        lessons[0] = _vocabWithStatus(
          lessons[0],
          LearningLessonStatus.notStarted,
        );
      }
    }

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (lesson.status != LearningLessonStatus.locked) continue;
      if (lesson.words.isEmpty) continue;

      if (i == 0) {
        lessons[i] = _vocabWithStatus(lesson, LearningLessonStatus.notStarted);
      } else if (lessons[i - 1].status == LearningLessonStatus.completed) {
        lessons[i] = _vocabWithStatus(lesson, LearningLessonStatus.notStarted);
      }
    }
    return lessons;
  }

  List<RoleplayQuickCheckLessonModel> _applyQuickCheckUnlock(
    List<RoleplayQuickCheckLessonModel> lessons,
    Map<String, LessonProgressModel> progress,
  ) {
    if (lessons.isEmpty) return lessons;

    if (progress.isEmpty ||
        !progress.values.any(
          (p) => p.type == RoleplayPracticeType.quickCheck.id,
        )) {
      if (lessons.first.questions.isNotEmpty) {
        lessons[0] = lessons[0].copyWith(
          status: LearningLessonStatus.notStarted,
        );
      }
    }

    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      if (lesson.status != LearningLessonStatus.locked) continue;
      if (lesson.questions.isEmpty) continue;

      if (i == 0) {
        lessons[i] = lesson.copyWith(status: LearningLessonStatus.notStarted);
      } else if (lessons[i - 1].status == LearningLessonStatus.completed) {
        lessons[i] = lesson.copyWith(status: LearningLessonStatus.notStarted);
      }
    }
    return lessons;
  }

  VocabularyLessonModel _vocabWithStatus(
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

  double scenarioProgress({
    required List<LearningLessonItem> lessons,
  }) {
    if (lessons.isEmpty) return 0;
    final completed =
        lessons.where((l) => l.status == LearningLessonStatus.completed).length;
    return completed / lessons.length;
  }
}
