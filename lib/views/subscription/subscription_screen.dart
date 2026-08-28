import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/subscription_view_model.dart';
import 'package:fluentta_ai/views/subscription/discount_paywall_screen.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/subscription/hearts_purchase_success_dialog.dart';
import 'package:fluentta_ai/widgets/subscription/subscription_plan_cards.dart';
import 'package:fluentta_ai/widgets/subscription/subscription_shared_widgets.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const SubscriptionScreen(),
      ),
    );
  }

  Future<void> _onClose(BuildContext context) async {
    Navigator.of(context).pop();
    // await DiscountPaywallScreen.open(context);
  }

  Future<void> _onPrimaryAction(BuildContext context) async {
    final vm = context.read<SubscriptionViewModel>();
    final l10n = context.l10n;

    if (vm.isPurchasing) return;

    final result = await vm.purchaseSelected();
    if (!context.mounted) return;

    if (!result.success) {
      if (result.message != null && result.message != 'Purchase canceled.') {
        SnackbarHelper.showSuccess(context, result.message!);
      }
      return;
    }

    if (result.heartsAdded != null && result.heartsAdded! > 0) {
      await showHeartsPurchaseSuccessDialog(
        context,
        heartsAdded: result.heartsAdded!,
      );
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    if (result.isPremium) {
      SnackbarHelper.showSuccess(context, l10n.includedInPlan);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _onRestore(BuildContext context) async {
    final vm = context.read<SubscriptionViewModel>();
    final l10n = context.l10n;
    final result = await vm.restorePurchases();
    if (!context.mounted) return;
    SnackbarHelper.showSuccess(
      context,
      result.success
          ? (result.message ?? l10n.restorePurchases)
          : (result.message ?? l10n.openingSoon),
    );
  }

  String _heartPackLabel(AppLocalizations l10n, HeartPackOption pack) {
    return switch (pack.labelKey) {
      'small' => l10n.smallPack,
      'medium' => l10n.mediumPack,
      'large' => l10n.largePack,
      _ => pack.labelKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final vm = context.watch<SubscriptionViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
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
                onPressed: () => _onClose(context),
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
                    Image.asset(
                      AppAssets.planBird,
                      height: AppSizes.h(140),
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: AppSizes.h(16)),
                    Text(
                      l10n.customPlanReady,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(26),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(8)),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
                      child: Text(
                        l10n.customPlanReadySub,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(15),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    SubscriptionPlanSummaryCard(
                      goalLabel: l10n.planGoalLabel,
                      levelLabel: l10n.planLevelLabel,
                      dailyLabel: l10n.planDailyLabel,
                      goalTitle: vm.goalLabel(l10n),
                      levelTitle: vm.levelLabel(l10n),
                      dailyTitle: l10n.dailyMinutesShort(vm.dailyMinutes),
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    SubscriptionFeatureList(
                      title: l10n.includedInPlan,
                      features: vm.planFeatures(l10n),
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    SubscriptionAnnualPlanCard(
                      isSelected: vm.selection == SubscriptionSelection.annual,
                      badge: l10n.bestValue,
                      title: l10n.annualPlan,
                      subtitle: l10n.threeDayFreeTrial,
                      price: vm.planPrice(SubscriptionSelection.annual, l10n),
                      perMonth: vm.planPricePerMonth(l10n),
                      onTap: () => vm.select(SubscriptionSelection.annual),
                    ),
                    SizedBox(height: AppSizes.h(12)),
                    Row(
                      children: [
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isSelected:
                                vm.selection == SubscriptionSelection.weekly,
                            title: l10n.weeklyPlan,
                            price: vm.planPrice(SubscriptionSelection.weekly, l10n),
                            onTap: () => vm.select(SubscriptionSelection.weekly),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(10)),
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isSelected:
                                vm.selection == SubscriptionSelection.monthly,
                            title: l10n.monthlyPlan,
                            price: vm.planPrice(SubscriptionSelection.monthly, l10n),
                            onTap: () => vm.select(SubscriptionSelection.monthly),
                          ),
                        ),
                        SizedBox(width: AppSizes.w(10)),
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isSelected:
                                vm.selection == SubscriptionSelection.lifetime,
                            title: l10n.lifetimePlan,
                            price: vm.planPrice(SubscriptionSelection.lifetime, l10n),
                            extraLabel: l10n.oneTime,
                            onTap: () =>
                                vm.select(SubscriptionSelection.lifetime),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(28)),
                    SubscriptionOrDivider(label: l10n.orDivider),
                    SizedBox(height: AppSizes.h(24)),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: AppColors.heartRed,
                          size: AppSizes.sp(20),
                        ),
                        SizedBox(width: AppSizes.w(8)),
                        Text(
                          l10n.needExtraHearts,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(16),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h(12)),
                    Row(
                      children: [
                        for (var i = 0; i < vm.heartPacks.length; i++) ...[
                          if (i > 0) SizedBox(width: AppSizes.w(10)),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final pack = vm.heartPacks[i];
                                return SubscriptionHeartPackCard(
                                  isSelected: vm.selection == pack.selection,
                                  title: _heartPackLabel(l10n, pack),
                                  heartsLabel: l10n.heartsCount(pack.hearts),
                                  price: pack.price,
                                  onTap: () => vm.select(pack.selection),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
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
                    text: vm.isHeartsSelection
                        ? l10n.buyHeartsCount(vm.selectedHeartCount)
                        : l10n.startFreeTrialDays(3),
                    onPressed: () => _onPrimaryAction(context),
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  Text(
                    vm.isHeartsSelection
                        ? l10n.heartsOneTimePurchase
                        : l10n.cancelAnytimeNoCharge,
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
                    onRestore: () => _onRestore(context),
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
