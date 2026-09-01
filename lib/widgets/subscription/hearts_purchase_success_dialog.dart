import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Future<void> showHeartsPurchaseSuccessDialog(
  BuildContext context, {
  required int heartsAdded,
}) {
  final l10n = context.l10n;
  final balance = context.read<HomeViewModel>().lives;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.w(28)),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(24)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(24),
            AppSizes.h(20),
            AppSizes.w(24),
            AppSizes.h(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.planSuccessBird,
                height: AppSizes.h(140),
                fit: BoxFit.contain,
              ),
              // SizedBox(height: AppSizes.h(16)),
              Text(
                l10n.heartsAddedTitle(heartsAdded),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(24),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(10)),
              Text(
                l10n.heartsAddedMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: AppSizes.h(20)),
              Container(
                width: AppSizes.screenWidth * .6,
                padding: EdgeInsets.all(AppSizes.w(16)),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/heart.svg',
                      color: AppColors.heartRed,
                      // size: AppSizes.sp(24),
                      width: AppSizes.sp(24),
                      height: AppSizes.sp(24),
                    ),
                    SizedBox(width: AppSizes.w(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.currentBalance,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          l10n.currentHeartsBalance(balance),
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(22),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h(20)),
              PrimaryButton(
                text: l10n.startPracticing,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              SizedBox(height: AppSizes.h(10)),
              Text(
                l10n.oneHeartPerAiResponse,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
