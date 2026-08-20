import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_complete_layout.dart';

class RoleplayQuickCheckCompleteScreen extends StatelessWidget {
  const RoleplayQuickCheckCompleteScreen({
    super.key,
    required this.lessonNumber,
    required this.lessonTitle,
    required this.questionCount,
    this.completionTitle,
    this.completionSummary,
  });

  final int lessonNumber;
  final String lessonTitle;
  final int questionCount;
  final String? completionTitle;
  final String? completionSummary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LessonCompleteLayout(
      title: completionTitle ?? '$questionCount Questions Learned',
      subtitle: completionSummary ??
          l10n.roleplayLessonCompleted(lessonNumber),
      buttonText: l10n.startNextLesson,
      onClose: () => Navigator.of(context).pop(),
      onButtonPressed: () => Navigator.of(context).pop(),
    );
  }
}
