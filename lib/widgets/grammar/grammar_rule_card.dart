import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';

class GrammarRuleCard extends StatelessWidget {
  const GrammarRuleCard({super.key, required this.step});

  final GrammarStepModel step;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color:isDark ?  AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color:isDark ? AppColors.borderDarkColor:AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(22),
                  fontWeight: FontWeight.w700,
                  color:isDark? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(6)),
              Text(
                step.description,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w500,
                  color:isDark ? AppColors.textSecondaryDark :AppColors.textSecondary ,
                  height: 1.4,
                ),
              ),
              SizedBox(height: AppSizes.spaceMd),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(14),
                  vertical: AppSizes.h(12),
                ),
                decoration: BoxDecoration(
                  color:isDark ? AppColors.brandDarkSoftColor :AppColors.brandLightSoftColor,
                  borderRadius: BorderRadius.circular(AppSizes.w(12)),
                  
                ),
                // foregroundDecoration: DottedDecoration(
                //   shape: Shape.box,
                //   borderRadius: BorderRadius.circular(AppSizes.w(12)),
                //   color: Color(0xffb6d2fd),
                //   strokeWidth: 1.5,
                //   dash: const [5, 4],
                // ),
                child: Text(
                  step.formula,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.white : const Color(0xFF00489E),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                AppAssets.yourLevelBird,
                width: AppSizes.w(70),
                height: AppSizes.w(70),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
