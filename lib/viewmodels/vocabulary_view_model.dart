import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_screen.dart';

class VocabularyViewModel extends ChangeNotifier {
  VocabularyViewModel(this._localStorage);

  final LocalStorage _localStorage;

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

  late List<VocabularyLessonModel> _lessons = _buildLessons();

  List<VocabularyLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == VocabularyLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  int get pathProgressPercent => (pathProgress * 100).round();

  String get levelCode {
    return switch (_localStorage.englishLevel) {
      'elementary' => 'A2',
      'intermediate' => 'B1',
      'advanced' => 'B2+',
      _ => 'A1',
    };
  }

  List<VocabularyLessonModel> _buildLessons() {
    return [
      const VocabularyLessonModel(
        id: 1,
        number: 1,
        title: 'Daily Words',
        status: VocabularyLessonStatus.completed,
        wordsCompleted: 5,
        totalWords: 5,
        iconName: 'check',
      ),
      VocabularyLessonModel(
        id: 2,
        number: 2,
        title: 'Workplace Words',
        status: VocabularyLessonStatus.inProgress,
        wordsCompleted: 3,
        totalWords: 5,
        iconName: 'chat',
        words: _workplaceWords,
      ),
      const VocabularyLessonModel(
        id: 3,
        number: 3,
        title: 'Travel Words',
        status: VocabularyLessonStatus.notStarted,
        wordsCompleted: 0,
        totalWords: 5,
        iconName: 'travel',
      ),
      VocabularyLessonModel(
        id: 4,
        number: 4,
        title: 'Workplace Words',
        status: VocabularyLessonStatus.notStarted,
        wordsCompleted: 0,
        totalWords: 5,
        iconName: 'chat',
        words: _workplaceWords,
      ),
      ...List.generate(6, (index) {
        final number = index + 5;
        const titles = [
          'Food',
          'Shopping',
          'Health',
          'School',
          'Family',
          'Hobbies',
        ];
        return VocabularyLessonModel(
          id: number,
          number: number,
          title: titles[index],
          status: VocabularyLessonStatus.locked,
          wordsCompleted: 0,
          totalWords: 5,
          iconName: 'lock',
        );
      }),
    ];
  }

  void openLesson(BuildContext context, VocabularyLessonModel lesson) {
    if (lesson.status == VocabularyLessonStatus.locked) return;
    if (lesson.words.isEmpty) {
      SnackbarHelper.showSuccess(context, 'Lesson content coming soon');
      return;
    }

    final startIndex = lesson.status == VocabularyLessonStatus.inProgress
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
          status: VocabularyLessonStatus.completed,
          wordsCompleted: lesson.totalWords,
          totalWords: lesson.totalWords,
          iconName: 'check',
          words: lesson.words,
        );
      }
      if (lesson.id == completedLesson.id + 1 &&
          lesson.status == VocabularyLessonStatus.locked) {
        return VocabularyLessonModel(
          id: lesson.id,
          number: lesson.number,
          title: lesson.title,
          status: VocabularyLessonStatus.notStarted,
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
}
