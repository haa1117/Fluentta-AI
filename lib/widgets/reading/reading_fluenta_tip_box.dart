import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReadingFluentaTipBox extends StatelessWidget {
  final bool isDark;
  const ReadingFluentaTipBox({super.key, required this.tip, required this.isDark});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding,
      
      
      ),
      

      decoration: BoxDecoration(
        color:isDark ? AppColors.brandDarkSoftColor : const Color(0xFFF0F4FF),
        // borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSizes.cardRadius),
          bottomRight: Radius.circular(AppSizes.cardRadius),

        )
        // border: Border.all(color: const Color(0xFFD3E4FE)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: AppSizes.w(4),
              decoration: BoxDecoration(
                color:isDark ? AppColors.brandDeepDarkColor : AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.cardRadius),
                  bottomLeft: Radius.circular(AppSizes.cardRadius),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.w(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/tip_outline.svg',
                      width: AppSizes.sp(22),
                      height: AppSizes.sp(22),
                      colorFilter:  ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: AppSizes.w(12)),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(13),
                            fontWeight: FontWeight.w500,
                            color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: 'Fluenta Tip\n',
                              style: TextStyle(
                                fontSize: AppSizes.sp(16),
                                fontWeight: FontWeight.w500,
                                color:isDark ?AppColors.textPrimaryDark : Color(0xff0B1C30),
                              ),
                            ),
                            TextSpan(text: tip),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
