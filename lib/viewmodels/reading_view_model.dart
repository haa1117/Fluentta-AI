import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/reading/reading_lesson_screen.dart';

class ReadingViewModel extends ChangeNotifier {
  ReadingViewModel(this._localStorage, this._localeViewModel) {
    _lessons = _buildLessons();
    _localeViewModel.addListener(_onLocaleChanged);
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;

  late List<ReadingLessonModel> _lessons;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<ReadingLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  LearningPathData get pathData => LearningPathData(
        title: _l10n.readingPathTitle(levelCode),
        subtitle: _l10n.readingPathSub,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode =>
      LocalizedContent.levelCode(_l10n, _localStorage.englishLevel);

  void _onLocaleChanged() {
    _lessons = _buildLessons();
    notifyListeners();
  }

  List<ReadingDialogueLineModel> _officeDialogueLines() => [
        ReadingDialogueLineModel(
          speakerLabel: _l10n.readingManager,
          text: _l10n.readingManagerLine,
          isUser: false,
        ),
        ReadingDialogueLineModel(
          speakerLabel: _l10n.readingYou,
          text: _l10n.readingYouLine,
          isUser: true,
        ),
      ];

  List<ReadingPhaseModel> _officeDialoguePhases() => List.generate(
        5,
        (index) => ReadingPhaseModel(
          phaseTitle: _l10n.readingDialoguePart(index + 1),
          lines: _officeDialogueLines(),
          tip: _l10n.readingFluentaTipText,
        ),
      );

  List<ReadingLessonModel> _buildLessons() {
    return [
      ReadingLessonModel(
        id: 1,
        number: 1,
        title: _l10n.lesson1DailyRoutine,
        status: LearningLessonStatus.completed,
        phasesCompleted: 5,
        totalPhases: 5,
        iconName: 'grammar',
      ),
      ReadingLessonModel(
        id: 2,
        number: 2,
        title: _l10n.lesson2OfficeDialogue,
        status: LearningLessonStatus.inProgress,
        phasesCompleted: 1,
        totalPhases: 5,
        iconName: 'chat',
        phases: _officeDialoguePhases(),
        completionTitle: _l10n.officeDialogueLearned,
        completionSummary: _l10n.generalOfficeConversation,
      ),
      ReadingLessonModel(
        id: 3,
        number: 3,
        title: _l10n.lesson3TravelStory,
        status: LearningLessonStatus.notStarted,
        phasesCompleted: 0,
        totalPhases: 5,
        iconName: 'travel',
        useLessonPrefix: false,
      ),
      ...[
        _l10n.lessonRestaurantTalk,
        _l10n.lessonFamilyStory,
        _l10n.lessonShoppingStory,
        _l10n.lessonDoctorVisit,
        _l10n.lessonWorkEmail,
        _l10n.lessonWeekendPlan,
        _l10n.lessonDirections,
      ].asMap().entries.map(
            (entry) => ReadingLessonModel(
              id: entry.key + 4,
              number: entry.key + 4,
              title: entry.value,
              status: LearningLessonStatus.locked,
              phasesCompleted: 0,
              totalPhases: 5,
              iconName: 'lock',
              useLessonPrefix: false,
            ),
          ),
    ];
  }

  void openLesson(BuildContext context, ReadingLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.phases.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.phasesCompleted.clamp(0, lesson.phases.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ReadingLessonScreen(
          lesson: lesson,
          initialPhaseIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
        ),
      ),
    );
  }

  void _markLessonCompleted(ReadingLessonModel completedLesson) {
    _lessons = _lessons.map((lesson) {
      if (lesson.id == completedLesson.id) {
        return ReadingLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.completed,
          phasesCompleted: lesson.totalPhases,
          totalPhases: lesson.totalPhases,
          iconName: 'check',
          useLessonPrefix: lesson.useLessonPrefix,
          phases: lesson.phases,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      }
      if (lesson.id == completedLesson.id + 1 &&
          lesson.status == LearningLessonStatus.locked) {
        return ReadingLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          phasesCompleted: 0,
          totalPhases: lesson.totalPhases,
          iconName: lesson.iconName == 'lock' ? 'travel' : lesson.iconName,
          useLessonPrefix: lesson.useLessonPrefix,
          phases: lesson.phases,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      }
      return lesson;
    }).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
