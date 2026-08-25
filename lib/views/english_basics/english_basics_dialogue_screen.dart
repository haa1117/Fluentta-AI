import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/english_basics/english_basics_step_header.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class EnglishBasicsDialogueScreen extends StatelessWidget {
  const EnglishBasicsDialogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Today's Lesson",
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.spaceMd),
          EnglishBasicsStepHeader(label: viewModel.stepLabel, progress: 0.85),
          SizedBox(height: AppSizes.spaceLg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.dialogueTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  lesson.dialogueSubtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              itemCount: lesson.dialogue.length,
              itemBuilder: (context, index) {
                return _DialogueBubble(
                  line: lesson.dialogue[index],
                  onSpeak: () => viewModel.speak(lesson.dialogue[index].text),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              AppSizes.spaceSm,
              AppSizes.horizontalPadding,
              AppSizes.spaceLg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => viewModel.completeLesson(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.w(28)),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogueBubble extends StatelessWidget {
  const _DialogueBubble({required this.line, required this.onSpeak});

  final EnglishBasicsDialogueLine line;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final isUser = line.isUser;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spaceMd),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            line.speaker,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isUser) ...[
                IconButton(
                  onPressed: onSpeak,
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.w(14)),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primaryColor : AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.w(16)),
                    border: isUser
                        ? null
                        : Border.all(color: AppColors.borderDarkPrimary),
                  ),
                  child: Text(
                    line.text,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w500,
                      color: isUser ? AppColors.white : AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (!isUser) ...[
                IconButton(
                  onPressed: onSpeak,
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
