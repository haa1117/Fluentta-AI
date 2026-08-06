import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/views/grammar/grammar_lesson_screen.dart';

class GrammarViewModel extends ChangeNotifier {
  GrammarViewModel(this._localStorage);

  final LocalStorage _localStorage;

  static const List<GrammarStepModel> _presentSimpleSteps = [
    GrammarStepModel(
      title: 'I You We',
      description: 'Use the base verb with I, you, and we.',
      formula: 'I / You / We + verb',
      examples: [
        GrammarExampleModel(
          prefix: 'I',
          highlight: 'work',
          suffix: '.',
        ),
        GrammarExampleModel(
          prefix: 'You',
          highlight: 'study',
          suffix: '.',
        ),
        GrammarExampleModel(
          prefix: 'We',
          highlight: 'speak',
          suffix: ' in English.',
        ),
      ],
      quickTip: 'Do not use \'s\' with i, you, we or they.',
    ),
    GrammarStepModel(
      title: 'He, She, It',
      description: 'With he, she, and it, add \'s\' to the verb.',
      formula: 'He / She / It + verb + s',
      examples: [
        GrammarExampleModel(
          prefix: 'He',
          highlight: 'works',
          suffix: '.',
        ),
        GrammarExampleModel(
          prefix: 'She',
          highlight: 'studies',
          suffix: '.',
          iconName: 'female'
        ),
        GrammarExampleModel(
          prefix: 'It',
          highlight: 'starts',
          suffix: ' now.',
          iconName: 'time',
        ),
      ],
      quickTip: 'He, she, and it usually need \'s\'.',
    ),
  ];

  late List<GrammarLessonModel> _lessons = _buildLessons();

  List<GrammarLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  LearningPathData get pathData => LearningPathData(
        title: '$levelCode Grammar Path',
        subtitle: 'Learn simple grammar rules\nstep by step.',
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode {
    return switch (_localStorage.englishLevel) {
      'elementary' => 'A2',
      'intermediate' => 'B1',
      'advanced' => 'B2+',
      _ => 'A1',
    };
  }

  List<GrammarLessonModel> _buildLessons() {
    return [
      const GrammarLessonModel(
        id: 1,
        number: 1,
        title: 'I am / you are',
        status: LearningLessonStatus.completed,
        stepsCompleted: 2,
        totalSteps: 2,
        iconName: 'grammar',
      ),
      GrammarLessonModel(
        id: 2,
        number: 2,
        title: 'Present Simple',
        status: LearningLessonStatus.inProgress,
        stepsCompleted: 1,
        totalSteps: 2,
        iconName: 'chat',
        steps: _presentSimpleSteps,
        completionTitle: 'Present Simple Learned',
        completionSummary: 'He, she, it, I, you, we',
      ),
      const GrammarLessonModel(
        id: 3,
        number: 3,
        title: 'A / an / The',
        status: LearningLessonStatus.notStarted,
        stepsCompleted: 0,
        totalSteps: 2,
        iconName: 'travel',
        useLessonPrefix: false,
      ),
      ...List.generate(7, (index) {
        const titles = [
          'This / That',
          'He / She / They',
          'There is / There are',
          'Can / Cannot',
          'Have / Has',
          'Was / Were',
          'Will / Going to',
        ];
        return GrammarLessonModel(
          id: index + 4,
          number: index + 4,
          title: titles[index],
          status: LearningLessonStatus.locked,
          stepsCompleted: 0,
          totalSteps: 2,
          iconName: 'lock',
          useLessonPrefix: false,
        );
      }),
    ];
  }

  void openLesson(BuildContext context, GrammarLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.steps.isEmpty) {
      SnackbarHelper.showSuccess(context, 'Lesson content coming soon');
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
}
