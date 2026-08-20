import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_lesson_screen.dart';

class RoleplayQuickCheckViewModel extends ChangeNotifier {
  RoleplayQuickCheckViewModel(
    this._scenarioId,
    this._localeViewModel,
    this._contentRepository,
    this._progressRepository,
    this._syncService,
  ) {
    _localeViewModel.addListener(_onLocaleChanged);
    _loadLessons();
  }

  final String _scenarioId;
  final LocaleViewModel _localeViewModel;
  final RoleplayContentRepository _contentRepository;
  final ProgressRepository _progressRepository;
  final ProgressSyncService _syncService;

  List<RoleplayQuickCheckLessonModel> _lessons = [];
  String _pathTitle = '';
  String _pathSubtitle = '';
  String _cefrLevel = 'A1';
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<RoleplayQuickCheckLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String get pathTitle => _pathTitle;
  String get pathSubtitle => _pathSubtitle;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  LearningPathData get pathData => LearningPathData(
        title: _pathTitle,
        subtitle: _pathSubtitle,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  Future<void> reload() => _loadLessons();

  Future<void> _loadLessons() async {
    _isLoading = true;
    notifyListeners();

    final path = await _contentRepository.getQuickCheckPath(_scenarioId);
    _pathTitle = path.pathTitle;
    _pathSubtitle = path.pathSubtitle;
    _cefrLevel = path.cefrLevel;

    _lessons = await _contentRepository.buildQuickCheckLessons(
      scenarioId: _scenarioId,
      progressRepository: _progressRepository,
    );

    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() => _loadLessons();

  void openLesson(BuildContext context, RoleplayQuickCheckLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.questions.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.questionsCompleted.clamp(0, lesson.questions.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoleplayQuickCheckLessonScreen(
          lesson: lesson,
          initialQuestionIndex: startIndex,
          cefrLevel: _cefrLevel,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
        ),
      ),
    );
  }

  Future<void> _saveInProgress(
    RoleplayQuickCheckLessonModel lesson,
    int index,
  ) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: RoleplayPracticeType.quickCheck.id,
      cefrLevel: _cefrLevel,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: RoleplayPracticeType.quickCheck.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(
    RoleplayQuickCheckLessonModel completedLesson,
  ) async {
    final orderedIds = _lessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: RoleplayPracticeType.quickCheck.id,
      cefrLevel: _cefrLevel,
      finalIndex: completedLesson.totalQuestions,
      unlockLessonId: nextId,
    );

    await _syncService.onLessonCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: RoleplayPracticeType.quickCheck.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalQuestions,
        updatedAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
    );

    await _loadLessons();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
