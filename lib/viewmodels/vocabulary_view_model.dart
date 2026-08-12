import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_screen.dart';

class VocabularyViewModel extends ChangeNotifier {
  VocabularyViewModel(this._localStorage, this._localeViewModel) {
    _lessons = _buildLessons();
    _localeViewModel.addListener(_onLocaleChanged);
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;

  static const List<VocabularyWordModel> _workplaceWords = [
    VocabularyWordModel(
      word: 'Meeting',
      phonetic: "/'miː.tɪŋ/",
      meaning: 'A time when people talk about work.',
      example: '"We have a meeting at 10 AM."',
    ),
    VocabularyWordModel(
      word: 'Report',
      phonetic: "/rɪˈpɔːt/",
      meaning: 'A document that gives information about work.',
      example: '"I finished the report today."',
    ),
    VocabularyWordModel(
      word: 'Deadline',
      phonetic: "/ˈded.laɪn/",
      meaning: 'The last day to finish something.',
      example: '"The deadline is Friday."',
    ),
    VocabularyWordModel(
      word: 'Manager',
      phonetic: "/ˈmæn.ɪ.dʒər/",
      meaning: 'A person who leads a team at work.',
      example: '"My manager is very helpful."',
    ),
    VocabularyWordModel(
      word: 'Office',
      phonetic: "/ˈɒf.ɪs/",
      meaning: 'A place where people work.',
      example: '"I go to the office every day."',
    ),
  ];

  late List<VocabularyLessonModel> _lessons;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<VocabularyLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  int get pathProgressPercent => (pathProgress * 100).round();

  LearningPathData get pathData => LearningPathData(
        title: _l10n.vocabularyPathTitle(levelCode),
        subtitle: _l10n.vocabularyPathSub,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode =>
      LocalizedContent.levelCode(_l10n, _localStorage.englishLevel);

  void _onLocaleChanged() {
    _lessons = _buildLessons();
    notifyListeners();
  }

  List<VocabularyLessonModel> _buildLessons() {
    return [
      VocabularyLessonModel(
        id: 1,
        number: 1,
        title: _l10n.lesson1DailyWords,
        status: LearningLessonStatus.completed,
        wordsCompleted: 5,
        totalWords: 5,
        iconName: 'check',
      ),
      VocabularyLessonModel(
        id: 2,
        number: 2,
        title: _l10n.lesson2WorkplaceWords,
        status: LearningLessonStatus.inProgress,
        wordsCompleted: 3,
        totalWords: 5,
        iconName: 'chat',
        words: _workplaceWords,
      ),
      VocabularyLessonModel(
        id: 3,
        number: 3,
        title: _l10n.lesson3TravelWords,
        status: LearningLessonStatus.notStarted,
        wordsCompleted: 0,
        totalWords: 5,
        iconName: 'travel',
      ),
      VocabularyLessonModel(
        id: 4,
        number: 4,
        title: _l10n.lesson2WorkplaceWords,
        status: LearningLessonStatus.notStarted,
        wordsCompleted: 0,
        totalWords: 5,
        iconName: 'chat',
        words: _workplaceWords,
      ),
      ...List.generate(6, (index) {
        const titleKeys = [
          'Food',
          'Shopping',
          'Health',
          'School',
          'Family',
          'Hobbies',
        ];
        return VocabularyLessonModel(
          id: index + 5,
          number: index + 5,
          title: titleKeys[index],
          status: LearningLessonStatus.locked,
          wordsCompleted: 0,
          totalWords: 5,
          iconName: 'lock',
        );
      }),
    ];
  }

  void openLesson(BuildContext context, VocabularyLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.words.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.wordsCompleted.clamp(0, lesson.words.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => VocabularyLessonScreen(
          lesson: lesson,
          initialWordIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
        ),
      ),
    );
  }

  void _markLessonCompleted(VocabularyLessonModel completedLesson) {
    _lessons = _lessons.map((lesson) {
      if (lesson.id == completedLesson.id) {
        return VocabularyLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.completed,
          wordsCompleted: lesson.totalWords,
          totalWords: lesson.totalWords,
          iconName: 'check',
          words: lesson.words,
        );
      }
      if (lesson.id == completedLesson.id + 1 &&
          lesson.status == LearningLessonStatus.locked) {
        return VocabularyLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: LearningLessonStatus.notStarted,
          wordsCompleted: 0,
          totalWords: lesson.totalWords,
          iconName: lesson.iconName == 'lock' ? 'travel' : lesson.iconName,
          words: lesson.words,
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
