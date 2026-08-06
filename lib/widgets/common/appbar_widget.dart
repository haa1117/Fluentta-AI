import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    this.title = 'Fluenta AI',
    this.showBackButton = false,
    this.centerTitle = false,
    this.onBack,
    this.showActionButton = true
  });

  final String title;
  final bool showBackButton;
  final bool centerTitle;
  final VoidCallback? onBack;
final bool showActionButton;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final lives = context.watch<HomeViewModel>().lives;

    return AppBar(
      backgroundColor: AppColors.white,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: showBackButton ? _BackButton(onBack: onBack) : null,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(18),
          fontWeight: FontWeight.w700,
          color: AppColors.primaryColor,
        ),
      ),
      actions:showActionButton ? [
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
                '$lives',
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
      ] : [],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.w(8)),
      child: Center(
        child: GestureDetector(
          onTap: onBack ?? () => Navigator.of(context).pop(),
          child: Container(
            width: AppSizes.w(40),
            height: AppSizes.w(40),
            decoration: BoxDecoration(
              color: AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/arrow_back_ios.svg',
                color: Color(0xff1F1B2E),
                width: AppSizes.sp(16),
                height: AppSizes.sp(16),


              ),
            ),
          ),
        ),
      ),
    );
  }
}
