import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/grammar_lesson_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GrammarExampleTile extends StatelessWidget {
  const GrammarExampleTile({
    super.key,
    required this.example,
    required this.exampleIndex,
  });

  final GrammarExampleModel example;
  final int exampleIndex;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GrammarLessonViewModel>();
    final isListening = viewModel.isExampleListening(exampleIndex);

    final iconPath = example.iconName == 'time'
        ? 'assets/svg/start_now.svg'
        : example.iconName == 'female'
            ? 'assets/svg/female_profile.svg'
            : 'assets/svg/profile.svg';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(
        left: AppSizes.horizontalPadding,
        right: AppSizes.horizontalPadding,
        bottom: AppSizes.spaceSm,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(14),
        vertical: AppSizes.h(12),
      ),
      decoration: BoxDecoration(
        color:isDark ?  AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        // border: Border.all(color: AppColors.borderDarkPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.w(36),
            height: AppSizes.w(36),
            decoration:
            BoxDecoration(
              color:isDark ? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: AppSizes.sp(13),
                height: AppSizes.sp(13),
                colorFilter:  ColorFilter.mode(
                 isDark ? AppColors.brandDeepDarkColor : AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w500,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
                children: [
                  TextSpan(text: '${example.prefix} '),
                  TextSpan(
                    text: example.highlight,
                    style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: example.suffix),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => viewModel.listenExample(context, example, exampleIndex),
            child: Icon(
              isListening ? Icons.volume_off_outlined : Icons.volume_up_outlined,
              color: isListening ? AppColors.primaryColor :isDark ? AppColors.textSecondaryDark : AppColors.iconColor,
              size: AppSizes.sp(20),
            ),
          ),
        ],
      ),
    );
  }
}
