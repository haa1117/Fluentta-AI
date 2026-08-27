import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/reading_lesson_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ReadingDialogueBubble extends StatelessWidget {
  const ReadingDialogueBubble({
    super.key,
    required this.line,
    required this.lineIndex,
    this.isListening,
    this.onListen,
  });

  final ReadingDialogueLineModel line;
  final int lineIndex;
  final bool? isListening;
  final void Function(BuildContext context)? onListen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final readingVm = onListen == null
        ? context.watch<ReadingLessonViewModel>()
        : null;
    final listening = isListening ?? readingVm!.isLineListening(lineIndex);
    final isUser = line.isUser;
    final speakerLabel = isUser ? l10n.readingYou : line.speakerLabel;

    void handleListen() {
      if (onListen != null) {
        onListen!(context);
      } else {
        readingVm!.listenLine(context, line, lineIndex);
      }
    }

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
            _SpeakerButton(
              color: AppColors.readingUserGreen,
              backgroundColor: AppColors.readingUserBubbleBg,
              isListening: listening,
              onTap: handleListen,
            ),
            SizedBox(width: AppSizes.w(12)),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(AppSizes.w(14)),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xffecfdf5) : AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.cardRadius),
                  topRight: Radius.circular(AppSizes.cardRadius),
                  bottomLeft: Radius.circular(
                    isUser ? AppSizes.cardRadius : AppSizes.w(0),
                  ),
                  bottomRight: Radius.circular(
                    isUser ? AppSizes.w(0) : AppSizes.cardRadius,
                  ),
                ),
                border: Border.all(
                  color: isUser
                      ? const Color(0xffc0efde)
                      : Color(0xffd3e4fe),
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
                    speakerLabel,
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
            SizedBox(width: AppSizes.w(12)),
            _SpeakerButton(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.homeCardLavender,
              isListening: listening,
              onTap: handleListen,
            ),
          ],
        ],
      ),
    );
  }
}

class _SpeakerButton extends StatelessWidget {
  const _SpeakerButton({
    required this.color,
    required this.backgroundColor,
    required this.onTap,
    this.isListening = false,
  });

  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool isListening;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: AppSizes.w(40),
          height: AppSizes.w(40),
          child: Center(
            child: isListening
                ? Icon(
                    Icons.volume_off_rounded,
                    color: color,
                    size: AppSizes.sp(20),
                  )
                : SvgPicture.asset(
                    'assets/svg/volume.svg',
                    width: AppSizes.sp(18),
                    height: AppSizes.sp(18),
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
          ),
        ),
      ),
    );
  }
}
