import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_screen.dart';

class GrammarViewModel extends ChangeNotifier {
  GrammarViewModel(this._localStorage, this._localeViewModel) {
    _lessons = _buildLessons();
    _localeViewModel.addListener(_onLocaleChanged);
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;

  late List<GrammarLessonModel> _lessons;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<GrammarLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  LearningPathData get pathData => LearningPathData(
        title: _l10n.grammarPathTitle(levelCode),
        subtitle: _l10n.grammarPathSub,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode =>
      LocalizedContent.levelCode(_l10n, _localStorage.englishLevel);

  void _onLocaleChanged() {
    _lessons = _buildLessons();
    notifyListeners();
  }

  List<GrammarStepModel> _presentSimpleSteps() => [
        GrammarStepModel(
          title: _l10n.grammarStepIYouWe,
          description: _l10n.grammarStepIYouWeDesc,
          formula: _l10n.grammarStepIYouWeFormula,
          examples: const [
            GrammarExampleModel(prefix: 'I', highlight: 'work', suffix: '.'),
            GrammarExampleModel(prefix: 'You', highlight: 'study', suffix: '.'),
            GrammarExampleModel(
              prefix: 'We',
              highlight: 'speak',
              suffix: ' in English.',
            ),
          ],
          quickTip: _l10n.grammarTipNoS,
        ),
        GrammarStepModel(
          title: _l10n.grammarStepHeSheIt,
          description: _l10n.grammarStepHeSheItDesc,
          formula: _l10n.grammarStepHeSheItFormula,
          examples: const [
            GrammarExampleModel(prefix: 'He', highlight: 'works', suffix: '.'),
            GrammarExampleModel(
              prefix: 'She',
              highlight: 'studies',
              suffix: '.',
              iconName: 'female',
            ),
            GrammarExampleModel(
              prefix: 'It',
              highlight: 'starts',
              suffix: ' now.',
              iconName: 'time',
            ),
          ],
          quickTip: _l10n.grammarTipNeedS,
        ),
      ];

  List<GrammarLessonModel> _buildLessons() {
    return [
      GrammarLessonModel(
        id: 1,
        number: 1,
        title: _l10n.lesson1IAmYouAre,
        status: LearningLessonStatus.completed,
        stepsCompleted: 2,
        totalSteps: 2,
        iconName: 'grammar',
      ),
      GrammarLessonModel(
        id: 2,
        number: 2,
        title: _l10n.lesson2PresentSimple,
        status: LearningLessonStatus.inProgress,
        stepsCompleted: 1,
        totalSteps: 2,
        iconName: 'chat',
        steps: _presentSimpleSteps(),
        completionTitle: _l10n.presentSimpleLearned,
        completionSummary: _l10n.presentSimpleSummary,
      ),
      GrammarLessonModel(
        id: 3,
        number: 3,
        title: _l10n.lessonArticles,
        status: LearningLessonStatus.notStarted,
        stepsCompleted: 0,
        totalSteps: 2,
        iconName: 'travel',
        useLessonPrefix: false,
      ),
      ...[
        _l10n.lessonThisThat,
        _l10n.lessonHeSheThey,
        _l10n.lessonThereIsAre,
        _l10n.lessonCanCannot,
        _l10n.lessonHaveHas,
        _l10n.lessonWasWere,
        _l10n.lessonWillGoingTo,
      ].asMap().entries.map(
            (entry) => GrammarLessonModel(
              id: entry.key + 4,
              number: entry.key + 4,
              title: entry.value,
              status: LearningLessonStatus.locked,
              stepsCompleted: 0,
              totalSteps: 2,
              iconName: 'lock',
              useLessonPrefix: false,
            ),
          ),
    ];
  }

  void openLesson(BuildContext context, GrammarLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.steps.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.stepsCompleted.clamp(0, lesson.steps.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => GrammarLessonScreen(
          lesson: lesson,
          initialStepIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
        ),
      ),
    );
  }

  void _markLessonCompleted(GrammarLessonModel completedLesson) {
    _lessons = _lessons.map((lesson) {
      if (lesson.id == completedLesson.id) {
        return GrammarLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.completed,
          stepsCompleted: lesson.totalSteps,
          totalSteps: lesson.totalSteps,
          iconName: 'check',
          useLessonPrefix: lesson.useLessonPrefix,
          steps: lesson.steps,
          completionTitle: lesson.completionTitle,
          completionSummary: lesson.completionSummary,
        );
      }
      if (lesson.id == completedLesson.id + 1 &&
          lesson.status == LearningLessonStatus.locked) {
        return GrammarLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          stepsCompleted: 0,
          totalSteps: lesson.totalSteps,
          iconName: lesson.iconName == 'lock' ? 'travel' : lesson.iconName,
          useLessonPrefix: lesson.useLessonPrefix,
          steps: lesson.steps,
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
