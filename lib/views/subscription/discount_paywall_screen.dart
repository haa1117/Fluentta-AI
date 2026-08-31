import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/subscription_view_model.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/subscription/subscription_shared_widgets.dart';
import 'package:provider/provider.dart';

class DiscountPaywallScreen extends StatelessWidget {
  const DiscountPaywallScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const DiscountPaywallScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<SubscriptionViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.h(8),
                AppSizes.horizontalPadding,
                0,
              ),
              child: SubscriptionCloseButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.horizontalPadding,
                  AppSizes.h(8),
                  AppSizes.horizontalPadding,
                  AppSizes.h(24),
                ),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          AppAssets.subscriptionProBird,
                          height: AppSizes.h(150),
                          fit: BoxFit.contain,
                        ),
                        Positioned(
                          right: AppSizes.w(24),
                          top: AppSizes.h(20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.w(10),
                              vertical: AppSizes.h(5),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCB45),
                              borderRadius: BorderRadius.circular(AppSizes.w(8)),
                            ),
                            child: Text(
                              l10n.fiftyPercentOff,
                              style: TextStyle(
                                fontFamily: AppFonts.plusJakartaSans,
                                fontSize: AppSizes.sp(12),
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    Text(
                      l10n.tryProForLess,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(28),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(8)),
                    Text(
                      l10n.fiftyOffFirstYear,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            AppSizes.w(18),
                            AppSizes.h(24),
                            AppSizes.w(18),
                            AppSizes.h(18),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppSizes.cardRadius),
                            border: Border.all(color: AppColors.borderLight),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor
                                    .withValues(alpha: 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.annualPro,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(14),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(10)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    vm.discountAnnualPrice(l10n),
                                    style: TextStyle(
                                      fontFamily: AppFonts.plusJakartaSans,
                                      fontSize: AppSizes.sp(28),
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.w(10)),
                                  Text(
                                    vm.discountAnnualStrikethrough(l10n),
                                    style: TextStyle(
                                      fontFamily: AppFonts.plusJakartaSans,
                                      fontSize: AppSizes.sp(14),
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textTertiary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.h(6)),
                              Text(
                                l10n.firstYearOnly,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(12),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(12)),
                              Text(
                                l10n.sevenDayFreeTrialIncluded,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(13),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -AppSizes.h(10),
                          right: AppSizes.w(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.w(10),
                              vertical: AppSizes.h(4),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCB45),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.w(6)),
                            ),
                            child: Text(
                              l10n.specialOffer,
                              style: TextStyle(
                                fontFamily: AppFonts.plusJakartaSans,
                                fontSize: AppSizes.sp(9),
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    SubscriptionFeatureList(
                      title: l10n.includedInPlan,
                      features:
                          context.read<SubscriptionViewModel>().planFeatures(l10n),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.h(16),
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    text: l10n.startSevenDayFreeTrial,
                    onPressed: vm.isPurchasing
                        ? null
                        : () async {
                            final result = await vm.purchaseDiscountAnnual();
                            if (!context.mounted) return;
                            if (result.success) {
                              SnackbarHelper.showSuccess(
                                context,
                                result.message ?? l10n.includedInPlan,
                              );
                              Navigator.of(context).pop();
                              return;
                            }
                            if (result.message != null &&
                                result.message != 'Purchase canceled.') {
                              SnackbarHelper.showSuccess(
                                context,
                                result.message!,
                              );
                            }
                          },
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  Text(
                    l10n.cancelAnytimeNoCharge,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  SubscriptionLegalLinks(
                    termsLabel: l10n.terms,
                    privacyLabel: l10n.privacy,
                    restoreLabel: l10n.restore,
                    onRestore: () async {
                      final result = await vm.restorePurchases();
                      if (!context.mounted) return;
                      SnackbarHelper.showSuccess(
                        context,
                        result.success
                            ? (result.message ?? l10n.restorePurchases)
                            : (result.message ?? l10n.openingSoon),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
