import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PracticeConversingCard extends StatelessWidget {
  final VoidCallback onStartChat;
  final bool isDark;
  const PracticeConversingCard({
    super.key,
    required this.onStartChat,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final circleFill = isDark
        ? AppColors.darkScaffoldBackgroundColor
        : AppColors.scaffoldBackgroundColor;
    final circleBorder =
        isDark ? AppColors.borderDarkColor : AppColors.borderLight;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
        borderRadius: BorderRadius.circular(AppSizes.w(12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.w(12),
          AppSizes.h(12),
          AppSizes.w(16),
          AppSizes.h(16),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppAssets.aiChatBird,
                  width: AppSizes.w(142),
                  height: AppSizes.w(142),
                  fit: BoxFit.contain,
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSizes.h(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.practiceConversing,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(20),
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.spaceMd),
                        Text(
                          l10n.practiceConversingSub,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: AppSizes.w(20)),
                _FigmaCircleIcon(
                  asset: AppAssets.chatMicIcon,
                  size: Size(AppSizes.w(11.667), AppSizes.h(15.833)),
                  fill: circleFill,
                  border: circleBorder,
                ),
                Transform.translate(
                  offset: Offset(-AppSizes.w(8), 0),
                  child: _FigmaCircleIcon(
                    asset: AppAssets.chatBubbleIcon,
                    size: Size(AppSizes.w(16.667), AppSizes.w(16.667)),
                    fill: circleFill,
                    border: circleBorder,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: HapticService.wrap(onStartChat),
                  child: Container(
                    width: AppSizes.w(176),
                    height: AppSizes.h(38),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.w(7)),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.startAiChat,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(6)),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.white,
                          size: AppSizes.sp(18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FigmaCircleIcon extends StatelessWidget {
  const _FigmaCircleIcon({
    required this.asset,
    required this.size,
    required this.fill,
    required this.border,
  });

  final String asset;
  final Size size;
  final Color fill;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.w(40),
      height: AppSizes.w(40),
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 0.5),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: SvgPicture.asset(asset),
      ),
    );
  }
}
