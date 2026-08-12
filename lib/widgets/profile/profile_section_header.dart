import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.w(4),
        bottom: AppSizes.h(8),
        top: AppSizes.h(4),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(13),
          fontWeight: FontWeight.w600,
          color: Color(0xff665D72),
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
