import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:fluentta_ai/widgets/vocabulary/vocabulary_word_card.dart';
import 'package:provider/provider.dart';

class VocabularyLessonScreen extends StatelessWidget {
  const VocabularyLessonScreen({
    super.key,
    required this.lesson,
    required this.initialWordIndex,
    required this.onLessonCompleted,
    this.onProgressChanged,
  });

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final ValueChanged<VocabularyLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VocabularyLessonViewModel(
        lesson: lesson,
        initialWordIndex: initialWordIndex,
        onLessonCompleted: onLessonCompleted,
        onProgressChanged: onProgressChanged,
        textToSpeechService: context.read<TextToSpeechService>(),
      ),
      child: _VocabularyLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _VocabularyLessonBody extends StatelessWidget {
  const _VocabularyLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<VocabularyLessonViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.lessonTitle(lessonNumber),
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        children: [
          SizedBox(height: AppSizes.spaceLg),
          LessonProgressBar(
            lessonNumber: lessonNumber,
            progress: viewModel.lessonProgress,
          ),
          SizedBox(height: AppSizes.spaceLg),
          const Center(child: VocabularyWordCard()),
          SizedBox(height: AppSizes.spaceXxl),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              0,
              AppSizes.horizontalPadding,
              AppSizes.spaceMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: LessonNavButton(
                    label: l10n.previousWord,
                    icon: Icons.arrow_back_rounded,
                    isPrimary: false,
                    enabled: !viewModel.isFirstWord,
                    iconOnRight: false,
                    onTap: viewModel.previousWord,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: LessonNavButton(
                    label: l10n.nextWord,
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: true,
                    iconOnRight: true,
                    onTap: () => viewModel.nextWord(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
