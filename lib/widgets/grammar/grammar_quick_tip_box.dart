import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GrammarQuickTipBox extends StatelessWidget {
  const GrammarQuickTipBox({super.key, required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: Color(0xfff0f1ff),
        border: Border.all(
          color: Color(0xffd3e4fe)
        ),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/svg/tip.svg',
            color: AppColors.primaryColor,

            width: AppSizes.sp(22),
            height: AppSizes.sp(22),

          ),
          SizedBox(width: AppSizes.w(15)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Quick Tip\n',
                    style: TextStyle(
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  TextSpan(text: tip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
