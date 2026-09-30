import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/english_basics/english_basics_step_header.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:provider/provider.dart';

class EnglishBasicsDialogueScreen extends StatelessWidget {
  const EnglishBasicsDialogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.todaysLessonTitle,
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.spaceMd),
          EnglishBasicsStepHeader(label: viewModel.stepLabelFor(l10n), progress: 0.85),
          SizedBox(height: AppSizes.spaceLg),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.dialogueTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(26),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(9)),
                Text(
                  lesson.dialogueSubtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
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
          FooterWidget(child: PrimaryButton(text: l10n.continueBtn, onPressed: () => viewModel.completeLesson()))

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final speakerColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final speakerBubble = isDark
        ? AppColors.surfaceBgDarkColor
        : AppColors.white;
    final speakerBorder =
        isDark ? AppColors.borderDarkColor : AppColors.borderLight;
    final speakerText =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final volumeBg =
        isDark ? AppColors.brandDarkSoftColor : const Color(0xffF3E8FF);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.spaceMd),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              line.speaker,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(11),
                fontWeight: FontWeight.w500,
                color: speakerColor,
              ),
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isUser) ...[
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: volumeBg,
                  ),
                  onPressed: HapticService.wrap(onSpeak),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    color: speakerColor,
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(AppSizes.w(14)),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primaryBlueColor : speakerBubble,
                    borderRadius: isUser
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(AppSizes.w(16)),
                            topLeft: Radius.circular(AppSizes.w(16)),
                            bottomRight: Radius.circular(AppSizes.w(16)),
                          )
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(AppSizes.w(16)),
                            topRight: Radius.circular(AppSizes.w(16)),
                            bottomRight: Radius.circular(AppSizes.w(16)),
                          ),
                    border: isUser ? null : Border.all(color: speakerBorder),
                  ),
                  child: Text(
                    line.text,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w500,
                      color: isUser ? AppColors.white : speakerText,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              if (!isUser) ...[
                const SizedBox(width: 10),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: volumeBg,
                  ),
                  onPressed: HapticService.wrap(onSpeak),
                  icon: Icon(
                    Icons.volume_up_outlined,
                    color: speakerColor,
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
