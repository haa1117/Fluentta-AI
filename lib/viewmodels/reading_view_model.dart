import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/views/reading/reading_lesson_screen.dart';

class ReadingViewModel extends ChangeNotifier {
  ReadingViewModel(this._localStorage);

  final LocalStorage _localStorage;

  static const _officeDialogueLines = [
    ReadingDialogueLineModel(
      speakerLabel: 'Manager',
      text: '"Can you join the meeting at 10?"',
      isUser: false,
    ),
    ReadingDialogueLineModel(
      speakerLabel: 'You',
      text: '"Yes, I can join the meeting."',
      isUser: true,
    ),
  ];

  static const _fluentaTip =
      'Try speaking the \'You\' response out loud to practice your office-ready pronunciation!';

  static List<ReadingPhaseModel> get _officeDialoguePhases => List.generate(
        5,
        (index) => ReadingPhaseModel(
          phaseTitle: 'Dialogue Part ${index + 1}',
          lines: _officeDialogueLines,
          tip: _fluentaTip,
        ),
      );

  late List<ReadingLessonModel> _lessons = _buildLessons();

  List<ReadingLessonModel> get lessons => _lessons;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  LearningPathData get pathData => LearningPathData(
        title: '$levelCode Reading Path',
        subtitle: 'Read short English passages\nstep by step.',
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

  List<ReadingLessonModel> _buildLessons() {
    return [
      const ReadingLessonModel(
        id: 1,
        number: 1,
        title: 'Daily Routine',
        status: LearningLessonStatus.completed,
        phasesCompleted: 5,
        totalPhases: 5,
        iconName: 'grammar',
      ),
      ReadingLessonModel(
        id: 2,
        number: 2,
        title: 'Office Dialogue',
        status: LearningLessonStatus.inProgress,
        phasesCompleted: 1,
        totalPhases: 5,
        iconName: 'chat',
        phases: _officeDialoguePhases,
        completionTitle: 'Office Dialogue Learned',
        completionSummary: 'General office conversation',
      ),
      const ReadingLessonModel(
        id: 3,
        number: 3,
        title: 'Travel Story',
        status: LearningLessonStatus.notStarted,
        phasesCompleted: 0,
        totalPhases: 5,
        iconName: 'travel',
        useLessonPrefix: false,
      ),
      ...List.generate(7, (index) {
        const titles = [
          'Restaurant Talk',
          'Family Story',
          'Shopping Story',
          'Doctor Visit',
          'Work Email',
          'Weekend Plan',
          'Directions',
        ];
        return ReadingLessonModel(
          id: index + 4,
          number: index + 4,
          title: titles[index],
          status: LearningLessonStatus.locked,
          phasesCompleted: 0,
          totalPhases: 5,
          iconName: 'lock',
          useLessonPrefix: false,
        );
      }),
    ];
  }

  void openLesson(BuildContext context, ReadingLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.phases.isEmpty) {
      SnackbarHelper.showSuccess(context, 'Lesson content coming soon');
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
}
