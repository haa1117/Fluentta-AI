import 'package:flutter/material.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_complete_layout.dart';

class VocabularyLessonCompleteScreen extends StatelessWidget {
  const VocabularyLessonCompleteScreen({
    super.key,
    required this.lessonNumber,
    required this.learnedWords,
  });

  final int lessonNumber;
  final List<String> learnedWords;

  @override
  Widget build(BuildContext context) {
    return LessonCompleteLayout(
      title: '${learnedWords.length} Words Learned',
      subtitle: 'You have completed Lesson $lessonNumber \n successfully',
      buttonText: 'Start Next Lesson',
      onClose: () => Navigator.of(context).pop(),
      onButtonPressed: () => Navigator.of(context).pop(),
      chips: learnedWords.map((word) => LessonCompleteChip(label: word)).toList(),
    );
  }
}
