import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_complete_layout.dart';

class VocabularyLessonCompleteScreen extends StatelessWidget {
  const VocabularyLessonCompleteScreen({
    super.key,
    required this.lessonNumber,
    required this.learnedWords,
    this.lessonId,
    this.xpEarned = LessonXpRewards.vocabularyLesson,
  });

  final int lessonNumber;
  final List<String> learnedWords;
  final String? lessonId;
  final int xpEarned;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LessonCompleteLayout(
      xpEarned: xpEarned,
      subtitle: l10n.lessonCompletedSuccess(lessonNumber),
      buttonText: l10n.startNextLesson,
      onClose: () => Navigator.of(context).pop(),
      onButtonPressed: () => Navigator.of(context).pop(),
      chips: learnedWords.map((word) => LessonCompleteChip(label: word)).toList(),
    );
  }
}
