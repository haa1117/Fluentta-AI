import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButtonWithIcon extends StatelessWidget {
  const PrimaryButtonWithIcon({
    super.key,
    required this.onTap,
    required this.btnText,
  });

  final VoidCallback onTap;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppSizes.screenWidth * .5,
        decoration: BoxDecoration(
          color: AppColors.primarySecondaryColor,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x336E00C1),
              offset: Offset(0, 3.57),
              blurRadius: 5.35,
              spreadRadius: -3.57,
            ),
            BoxShadow(
              color: Color(0x336E00C1),
              offset: Offset(0, 8.92),
              blurRadius: 13.39,
              spreadRadius: -2.68,
            ),
          ],
        ),
        height: AppSizes.h(48),
        child:Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mic_none_rounded, size: AppSizes.sp(21),

                color: AppColors.white,
              ),
              SizedBox(
                width: AppSizes.spaceSm,
              ),

              Text(
                btnText,
                style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w700,
                    color: AppColors.white
                ),
              )
            ],
          ),
        ) ,
        // child: ElevatedButton.icon(
        //   onPressed: onStartChat,
        //   icon: Icon(Icons.mic_none_rounded, size: AppSizes.sp(20)),
        //   label: Text(
        //     l10n.startAiChat,
        //     style: TextStyle(
        //       fontFamily: AppFonts.plusJakartaSans,
        //       fontSize: AppSizes.sp(15),
        //       fontWeight: FontWeight.w700,
        //     ),
        //   ),
        //   style: ElevatedButton.styleFrom(
        //     // backgroundColor: AppColors.primarySecondaryColor,
        //     foregroundColor: AppColors.white,
        //     elevation: 0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
