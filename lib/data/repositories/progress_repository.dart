import 'dart:convert';

import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';

class ProgressRepository {
  ProgressRepository(this._localStorage);

  final LocalStorage _localStorage;
  static const String _storageKey = 'lesson_progress_v1';

  Map<String, LessonProgressModel> _cache = {};
  bool _loaded = false;

  Future<void> initialize() async {
    if (_loaded) return;
    final raw = _localStorage.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _cache = json.map(
        (key, value) => MapEntry(
          key,
          LessonProgressModel.fromJson(value as Map<String, dynamic>),
        ),
      );
    }
    _loaded = true;
  }

  Map<String, LessonProgressModel> get allProgress => Map.unmodifiable(_cache);

  Future<LessonProgressModel?> getProgress(String lessonId) async {
    await initialize();
    return _cache[lessonId];
  }

  Future<void> saveProgress(LessonProgressModel progress) async {
    await initialize();
    _cache[progress.lessonId] = progress;
    await _persist();
  }

  Future<void> saveInProgress({
    required String lessonId,
    required String type,
    required String cefrLevel,
    required int currentIndex,
  }) async {
    await saveProgress(
      LessonProgressModel(
        lessonId: lessonId,
        type: type,
        cefrLevel: cefrLevel,
        status: LearningLessonStatus.inProgress,
        currentIndex: currentIndex,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> markCompleted({
    required String lessonId,
    required String type,
    required String cefrLevel,
    required int finalIndex,
    String? unlockLessonId,
  }) async {
    await initialize();
    final completed = LessonProgressModel(
      lessonId: lessonId,
      type: type,
      cefrLevel: cefrLevel,
      status: LearningLessonStatus.completed,
      currentIndex: finalIndex,
      updatedAt: DateTime.now(),
      completedAt: DateTime.now(),
    );
    _cache = LessonUnlockLogic.applyCompletion(
      current: _cache,
      completed: completed,
      unlockLessonId: unlockLessonId,
    );
    await _persist();
  }

  Future<void> mergeRemoteProgress(
    Map<String, LessonProgressModel> remote,
  ) async {
    await initialize();
    for (final entry in remote.entries) {
      final local = _cache[entry.key];
      if (local == null || entry.value.isNewerThan(local)) {
        _cache[entry.key] = entry.value;
      }
    }
    await _persist();
  }

  Future<void> _persist() async {
    final json = _cache.map((key, value) => MapEntry(key, value.toJson()));
    await _localStorage.setString(_storageKey, jsonEncode(json));
  }
}
