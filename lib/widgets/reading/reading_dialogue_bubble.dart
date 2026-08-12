import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';

class ReadingDialogueBubble extends StatelessWidget {
  const ReadingDialogueBubble({super.key, required this.line});

  final ReadingDialogueLineModel line;

  @override
  Widget build(BuildContext context) {
    final isUser = line.isUser;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.horizontalPadding,
        right: AppSizes.horizontalPadding,
        bottom: AppSizes.spaceMd,
      ),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isUser) ...[
            Center(
              child: _SpeakerButton(
                color: AppColors.readingUserGreen,
                onTap: () => SnackbarHelper.showSuccess(
                  context,
                  'Playing "${line.text}"...',
                ),
              ),
            ),
            SizedBox(width: AppSizes.w(15)),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(AppSizes.w(14)),
              decoration: BoxDecoration(
                color: isUser
                    ? Color(0xffecfdf5)
                    : AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.cardRadius),
                  topLeft: Radius.circular(AppSizes.cardRadius),
                  topRight: Radius.circular(AppSizes.cardRadius)

                ),
                // borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(
                  color: isUser
                      ? Color(0xffc0efde)
                      : AppColors.borderDarkPrimary,
                ),
                boxShadow: isUser
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.speakerLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(13),
                      fontWeight: FontWeight.w700,
                      color: isUser
                          ? AppColors.readingUserGreen
                          : AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    line.text,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isUser) ...[
            SizedBox(width: AppSizes.w(8)),
            _SpeakerButton(
              color: AppColors.primaryColor,
              onTap: () => SnackbarHelper.showSuccess(
                context,
                'Playing "${line.text}"...',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpeakerButton extends StatelessWidget {
  const _SpeakerButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Icon(
          Icons.volume_up_outlined,
          color: color.withValues(alpha: 0.7),
          size: AppSizes.sp(22),
        ),
      ),
    );
  }
}
