import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return AppBar(
      backgroundColor: AppColors.white,
      scrolledUnderElevation: 0.0,
      title: Text(
        'Fluenta AI',
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(18),
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: AppSizes.w(16)),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(12),
            vertical: AppSizes.h(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.homeCardLavender,
            borderRadius: BorderRadius.circular(AppSizes.w(20)),
          ),
          child: Row(
            children: [
              Text(
                '${viewModel.lives}',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: AppSizes.w(4)),
              Icon(
                Icons.favorite,
                color: AppColors.heartRed,
                size: AppSizes.sp(16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}