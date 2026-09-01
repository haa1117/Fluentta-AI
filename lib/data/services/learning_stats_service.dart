import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';

/// Keeps profile learning stats aligned with real lesson progress.
class LearningStatsService {
  LearningStatsService(this._localStorage, this._progressRepository);

  final LocalStorage _localStorage;
  final ProgressRepository _progressRepository;

  int get xpEarned => _localStorage.xpEarned;

  int get wordsCount => _localStorage.wordsLearnedCount;

  int get lessonsCount => _localStorage.lessonsCompletedCount;

  int get correctionsCount => _localStorage.correctionsCount;

  Future<void> reconcileFromProgress() async {
    await _progressRepository.initialize();

    final completed = _progressRepository.allProgress.values.where(
      (progress) => progress.status == LearningLessonStatus.completed,
    );

    final lessonsCompleted = completed.length;

    var wordsFromLessons = 0;
    for (final progress in completed) {
      if (progress.type == 'vocabulary' || progress.type == 'roleplay_vocab') {
        wordsFromLessons += progress.currentIndex;
      }
    }

    final mergedWords = wordsFromLessons > _localStorage.wordsLearnedCount
        ? wordsFromLessons
        : _localStorage.wordsLearnedCount;

    await _localStorage.saveStats(
      wordsLearnedCount: mergedWords,
      lessonsCompletedCount: lessonsCompleted,
    );
  }

  Future<void> recordCorrections(int count) async {
    if (count <= 0) return;
    await _localStorage.incrementCorrectionsCount(count);
  }

  Future<void> mergeRemoteStats({
    int? xpEarned,
    int? wordsLearnedCount,
    int? lessonsCompletedCount,
    int? correctionsCount,
  }) async {
    await _localStorage.saveStats(
      xpEarned: _maxNullable(xpEarned, _localStorage.xpEarned),
      wordsLearnedCount:
          _maxNullable(wordsLearnedCount, _localStorage.wordsLearnedCount),
      lessonsCompletedCount: _maxNullable(
        lessonsCompletedCount,
        _localStorage.lessonsCompletedCount,
      ),
      correctionsCount:
          _maxNullable(correctionsCount, _localStorage.correctionsCount),
    );
  }

  int? _maxNullable(int? remote, int local) {
    if (remote == null) return null;
    return remote > local ? remote : local;
  }
}
