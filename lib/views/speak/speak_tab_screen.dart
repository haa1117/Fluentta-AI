import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/l10n/roleplay_scenario_l10n.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/roleplay_scenario_model.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/viewmodels/ai_tutor_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_scenario_detail_screen.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_scenario_card.dart';
import 'package:fluentta_ai/widgets/common/pro_feature_sheet.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:fluentta_ai/widgets/speak/speak_ai_tutor_card.dart';
import 'package:provider/provider.dart';

const String _kRolePlayScreenId = 'role_play';

class RolePlayScreen extends StatelessWidget {
  const RolePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiTutorViewModel(context.read<HomeViewModel>()),
      child: const _RolePlayTabBody(),
    );
  }
}

class _RolePlayTabBody extends StatefulWidget {
  const _RolePlayTabBody();

  @override
  State<_RolePlayTabBody> createState() => _RolePlayTabBodyState();
}

class _RolePlayTabBodyState extends State<_RolePlayTabBody> {
  bool _loggedViewed = false;

  void _showRoleplayLockSheet(
    BuildContext context,
    String sourceScreen,
    String scenarioId,
  ) {
    final l10n = context.l10n;
    void logUpsell(String event, {String? destinationScreen}) {
      AnalyticsService.instance.log(event, {
        AnalyticsParams.sourceScreen: sourceScreen,
        AnalyticsParams.featureContext: 'advanced_roleplay_scenario',
        AnalyticsParams.scenarioId: scenarioId,
        if (destinationScreen != null)
          AnalyticsParams.destinationScreen: destinationScreen,
      });
    }

    showProFeatureSheet(
      context,
      title: l10n.advancedRoleplay,
      showWatchAd: false,
      message: l10n.upgradeToUnlockRoleplays,
      onShown: () => logUpsell(AnalyticsEvents.premiumUpsellViewed),
      onGoUnlimitedTapped: () => logUpsell(
        AnalyticsEvents.premiumUpsellGoUnlimitedClicked,
        destinationScreen: 'paywall',
      ),
      onDismissedWithoutAction: () =>
          logUpsell(AnalyticsEvents.premiumUpsellDismissed),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final homeViewModel = context.watch<HomeViewModel>();
    final aiTutorViewModel = context.watch<AiTutorViewModel>();
    final livesLabel = homeViewModel.hasUnlimitedHearts
        ? '∞'
        : '${homeViewModel.lives}';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scenarios = aiTutorViewModel.orderedScenarios;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView(_kRolePlayScreenId);
      AnalyticsService.instance.log(AnalyticsEvents.rolePlayViewed, {
        // Reached only via the bottom nav tab today; no internal-navigation
        // or deep-link entry point exists yet for this screen.
        AnalyticsParams.entrySource: 'bottom_nav',
        AnalyticsParams.currentXp: homeViewModel.xpEarned,
        AnalyticsParams.subscriptionTierAtEvent:
            homeViewModel.isPro ? 'premium' : 'free',
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.rolePlayTitle,
        xpIconSourceScreen: _kRolePlayScreenId,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.horizontalPadding,
            AppSizes.spaceMd,
            AppSizes.horizontalPadding,
            AppSizes.spaceLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpeakAiTutorCard(
                livesLabel: livesLabel,
                onStartPractice: () {
                  AnalyticsService.instance.log(
                    AnalyticsEvents.pronunciationPracticeClicked,
                    {
                      AnalyticsParams.sourceScreen: _kRolePlayScreenId,
                      AnalyticsParams.destinationScreen:
                          'pronunciation_practice',
                    },
                  );
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const PronunciationFlow(),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSizes.spaceMd),

              Text(
                l10n.roleplayScenarios,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(18),
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceMd),
              SizedBox(
                height: RoleplayScenarioCard.listExtent(context),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: scenarios.length,
                  separatorBuilder: (_, index) =>
                      SizedBox(width: AppSizes.w(12)),
                  itemBuilder: (context, index) {
                    final scenario = scenarios[index];
                    final title = RoleplayScenarioL10n.listTitle(
                      l10n,
                      scenario.id,
                    );
                    return RoleplayScenarioCard(
                      isDark: isDark,
                      scenario: RoleplayScenarioModel(
                        id: scenario.id,
                        title: title,
                        icon: scenario.icon,
                        imagePath: scenario.imagePath,
                        progress: scenario.progress,
                      ),
                      isSelected:
                          aiTutorViewModel.selectedScenarioId == scenario.id,
                      isLocked: !context
                          .read<EntitlementsService>()
                          .canAccessRoleplayScenario(scenario.id),
                      isAdvanced: UserEntitlements.advancedRoleplayScenarioIds
                          .contains(scenario.id),
                      onTap: () {
                        final entitlements = context
                            .read<EntitlementsService>();
                        if (!entitlements.canAccessRoleplayScenario(
                          scenario.id,
                        )) {
                          AnalyticsService.instance.log(
                            AnalyticsEvents.roleplayScenarioLockedClicked,
                            {
                              AnalyticsParams.sourceScreen: _kRolePlayScreenId,
                              AnalyticsParams.scenarioId: scenario.id,
                              AnalyticsParams.lockReason: 'premium',
                            },
                          );
                          _showRoleplayLockSheet(
                            context,
                            _kRolePlayScreenId,
                            scenario.id,
                          );
                          return;
                        }
                        AnalyticsService.instance.log(
                          AnalyticsEvents.rolePlayScenarioClicked,
                          {
                            AnalyticsParams.scenarioId: scenario.id,
                            AnalyticsParams.scenarioState:
                                aiTutorViewModel.isScenarioXpUnlocked(
                                  scenario.id,
                                )
                                    ? 'unlocked'
                                    : 'locked',
                            AnalyticsParams.sourceScreen: _kRolePlayScreenId,
                            AnalyticsParams.destinationScreen:
                                'role_play_scenario',
                          },
                        );
                        aiTutorViewModel.selectScenario(scenario.id);
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => RoleplayScenarioDetailScreen(
                              scenarioId: scenario.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeBannerAd(
        placement: AdPlacement.roleplayBanner,
        bottomPadding: AppSizes.spaceSm,
      ),
    );
  }
}
