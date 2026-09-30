import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/legal_urls.dart';
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
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/subscription/hearts_purchase_success_dialog.dart';
import 'package:fluentta_ai/widgets/subscription/premium_unlocked_dialog.dart';
import 'package:fluentta_ai/widgets/subscription/subscription_plan_cards.dart';
import 'package:fluentta_ai/widgets/subscription/subscription_shared_widgets.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  /// [featureTrigger] identifies what surfaced the paywall (e.g.
  /// `out_of_hearts`, `profile_upsell`); defaults to `other` for entry
  /// points that don't yet pass one through.
  static Future<void> open(
    BuildContext context, {
    String featureTrigger = 'other',
  }) {
    context.read<SubscriptionViewModel>().startPaywallSession(
          featureTrigger: featureTrigger,
        );
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SubscriptionScreen()),
    );
  }

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _loggedViewed = false;

  String _planTypeLabel(SubscriptionSelection selection) {
    return switch (selection) {
      SubscriptionSelection.annual => 'annual',
      SubscriptionSelection.weekly => 'weekly',
      SubscriptionSelection.monthly => 'monthly',
      SubscriptionSelection.lifetime => 'lifetime',
      _ => 'unknown',
    };
  }

  void _logPlanSelected(SubscriptionViewModel vm, SubscriptionSelection selection) {
    vm.select(selection);
    AnalyticsService.instance.log(AnalyticsEvents.paywallPlanSelected, {
      AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
      AnalyticsParams.planType: _planTypeLabel(selection),
    });
  }

  void _logHeartPackSelected(SubscriptionViewModel vm, HeartPackOption pack) {
    vm.select(pack.selection);
    AnalyticsService.instance.log(AnalyticsEvents.heartPackSelected, {
      AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
      AnalyticsParams.heartPackSize: pack.hearts,
    });
  }

  Future<void> _onClose(BuildContext context) async {
    final vm = context.read<SubscriptionViewModel>();
    AnalyticsService.instance.log(AnalyticsEvents.paywallClosed, {
      AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
      // discount_paywall doesn't exist/isn't wired in this app, so closing
      // the paywall always means the user exited it outright.
      AnalyticsParams.closeOutcome: 'paywall_exited',
    });
    Navigator.of(context).pop();
  }

  Future<void> _onPrimaryAction(BuildContext context) async {
    final vm = context.read<SubscriptionViewModel>();

    if (vm.isPurchasing) return;

    AnalyticsService.instance.log(AnalyticsEvents.paywallCtaClicked, {
      AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
      if (vm.isHeartsSelection)
        AnalyticsParams.heartPackSize: vm.selectedHeartCount
      else
        AnalyticsParams.planType: _planTypeLabel(vm.selection),
    });

    final result = await vm.purchaseSelected();
    if (!context.mounted) return;

    if (!result.success) {
      if (result.message != null && !result.isCanceled) {
        SnackbarHelper.showError(context, result.message!);
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
      await showPremiumUnlockedDialog(context);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _onRestore(BuildContext context) async {
    final vm = context.read<SubscriptionViewModel>();
    final l10n = context.l10n;
    AnalyticsService.instance.log(AnalyticsEvents.restorePurchaseClicked, {
      AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('personalized_paywall');
      AnalyticsService.instance.log(AnalyticsEvents.paywallViewed, {
        AnalyticsParams.conversionJourneyId: vm.conversionJourneyId,
        AnalyticsParams.paywallVariant: 'personalized_plan_v1',
        AnalyticsParams.offerSequence: 1,
        AnalyticsParams.featureTrigger: vm.paywallFeatureTrigger,
      });
    }

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
                isDark: isDark,
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
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.horizontalPadding,
                      ),
                      child: Text(
                        l10n.customPlanReadySub,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(15),
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
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
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    SubscriptionFeatureList(
                      title: l10n.includedInPlan,
                      features: vm.planFeatures(l10n),
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSizes.h(24)),
                    SubscriptionAnnualPlanCard(
                      isSelected: vm.selection == SubscriptionSelection.annual,
                      badge: l10n.bestValue,
                      title: l10n.annualPlan,
                      subtitle: l10n.sevenDayFreeTrial,
                      price: vm.planPrice(SubscriptionSelection.annual, l10n),
                      perMonth: vm.planPricePerMonth(l10n),
                      onTap: () =>
                          _logPlanSelected(vm, SubscriptionSelection.annual),
                      isDark: isDark,
                    ),
                    SizedBox(height: AppSizes.h(12)),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isSelected:
                                vm.selection == SubscriptionSelection.weekly,
                            title: l10n.weeklyPlan,
                            price: vm.planPrice(
                              SubscriptionSelection.weekly,
                              l10n,
                            ),
                            onTap: () => _logPlanSelected(
                              vm,
                              SubscriptionSelection.weekly,
                            ),
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(10)),
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isSelected:
                                vm.selection == SubscriptionSelection.monthly,
                            title: l10n.monthlyPlan,
                            price: vm.planPrice(
                              SubscriptionSelection.monthly,
                              l10n,
                            ),
                            onTap: () => _logPlanSelected(
                              vm,
                              SubscriptionSelection.monthly,
                            ),
                            isDark: isDark,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(10)),
                        Expanded(
                          child: SubscriptionCompactPlanCard(
                            isDark: isDark,
                            isSelected: vm.selection ==
                                SubscriptionSelection.lifetime,
                            title: l10n.lifetimePlan,
                            price: vm.planPrice(
                              SubscriptionSelection.lifetime,
                              l10n,
                            ),
                            onTap: () => _logPlanSelected(
                              vm,
                              SubscriptionSelection.lifetime,
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                    SizedBox(height: AppSizes.h(28)),
                    SubscriptionOrDivider(
                      label: l10n.orDivider,
                      isDark: isDark,
                    ),
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
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
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
                                  onTap: () => _logHeartPackSelected(vm, pack),
                                  isDark: isDark,
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
                    text: vm.primaryButtonText(l10n),
                    onPressed: () => _onPrimaryAction(context),
                  ),
                  SizedBox(height: AppSizes.h(10)),
                  Text(
                    vm.primaryDisclaimer(l10n),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  SubscriptionLegalLinks(
                    termsLabel: l10n.termsOfUse,
                    privacyLabel: l10n.privacyPolicy,
                    restoreLabel: l10n.restore,
                    onRestore: () => _onRestore(context),
                    onPrivacy: () => LegalUrls.openPrivacyPolicy(context),
                    onTerms: () => LegalUrls.openTermsOfUse(context),
                    isDark: isDark,
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
