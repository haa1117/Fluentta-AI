import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/l10n/roleplay_scenario_l10n.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/viewmodels/ai_tutor_view_model.dart';
import 'package:fluentta_ai/viewmodels/roleplay_scenario_detail_view_model.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_dialogue_path_screen.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_path_screen.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_vocabulary_path_screen.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_cefr_level_bar.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_practice_option_tile.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_scenario_overview_card.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/common/pro_feature_sheet.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:provider/provider.dart';

const String _kScenarioDetailScreenId = 'role_play_scenario';

class RoleplayScenarioDetailScreen extends StatefulWidget {
  const RoleplayScenarioDetailScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  State<RoleplayScenarioDetailScreen> createState() =>
      _RoleplayScenarioDetailScreenState();
}

class _RoleplayScenarioDetailScreenState
    extends State<RoleplayScenarioDetailScreen> {
  bool _loggedViewed = false;
  bool _loggedLockedClick = false;

  void _logUpsell(String event, String scenarioId, {String? destinationScreen}) {
    AnalyticsService.instance.log(event, {
      AnalyticsParams.sourceScreen: _kScenarioDetailScreenId,
      AnalyticsParams.featureContext: 'advanced_roleplay_scenario',
      AnalyticsParams.scenarioId: scenarioId,
      if (destinationScreen != null)
        AnalyticsParams.destinationScreen: destinationScreen,
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final scenario = AiTutorViewModel.scenarioById(widget.scenarioId);

    if (scenario != null &&
        !context.read<EntitlementsService>().canAccessRoleplayScenario(
          scenario.id,
        )) {
      if (!_loggedLockedClick) {
        _loggedLockedClick = true;
        AnalyticsService.instance.log(
          AnalyticsEvents.roleplayScenarioLockedClicked,
          {
            AnalyticsParams.sourceScreen: _kScenarioDetailScreenId,
            AnalyticsParams.scenarioId: scenario.id,
            AnalyticsParams.lockReason: 'premium',
          },
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showProFeatureSheet(
          context,
          title: l10n.advancedRoleplay,
          message: l10n.upgradeToUnlockRoleplays,
          onShown: () =>
              _logUpsell(AnalyticsEvents.premiumUpsellViewed, scenario.id),
          onGoUnlimitedTapped: () => _logUpsell(
            AnalyticsEvents.premiumUpsellGoUnlimitedClicked,
            scenario.id,
            destinationScreen: 'paywall',
          ),
          onDismissedWithoutAction: () => _logUpsell(
            AnalyticsEvents.premiumUpsellDismissed,
            scenario.id,
          ),
        );
        Navigator.of(context).pop();
      });
    }

    if (scenario == null) {
      return Scaffold(
        appBar: AppBarWidget(
          title: l10n.aiTutor,
          showBackButton: true,
          centerTitle: true,
        ),
        body: Center(child: Text(l10n.scenarioNotFound)),
      );
    }

    final detailTitle = RoleplayScenarioL10n.detailTitle(l10n, scenario.id);

    return ChangeNotifierProvider(
      create: (context) => RoleplayScenarioDetailViewModel(
        scenarioId: scenario.id,
        learningStatsService: context.read<LearningStatsService>(),
        contentRepository: context.read<RoleplayContentRepository>(),
        progressRepository: context.read<ProgressRepository>(),
        progressSyncService: context.read<ProgressSyncService>(),
      ),
      child: Consumer<RoleplayScenarioDetailViewModel>(
        builder: (context, detailVm, _) {
          if (detailVm.isLoading) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground(context),
              appBar: AppBarWidget(
                title: detailTitle,
                showBackButton: true,
                centerTitle: true,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          final level = detailVm.selectedLevel;
          final levelCode = CefrLevelProgress.levelCodeLabel(l10n, level);
          final levelLabel = CefrLevelProgress.levelNameLabel(l10n, level);
          final isDark = Theme.of(context).brightness == Brightness.dark;

          if (!_loggedViewed) {
            _loggedViewed = true;
            AnalyticsService.instance.logScreenView(_kScenarioDetailScreenId);
            AnalyticsService.instance.log(
              AnalyticsEvents.rolePlayScenarioViewed,
              {
                AnalyticsParams.scenarioId: scenario.id,
                AnalyticsParams.cefrLevel: levelCode,
                AnalyticsParams.scenarioProgressPercent:
                    (detailVm.moduleProgress * 100).round(),
                AnalyticsParams.completedModuleCount:
                    detailVm.completedModuleCount,
              },
            );
          }

          void openModule(
            String moduleType,
            String destinationScreen,
            RoleplayModuleState moduleState,
            WidgetBuilder builder,
          ) {
            AnalyticsService.instance.log(
              AnalyticsEvents.rolePlayModuleClicked,
              {
                AnalyticsParams.scenarioId: scenario.id,
                AnalyticsParams.cefrLevel: levelCode,
                AnalyticsParams.moduleType: moduleType,
                AnalyticsParams.moduleState: moduleState.analyticsValue,
                AnalyticsParams.sourceScreen: _kScenarioDetailScreenId,
                AnalyticsParams.destinationScreen: destinationScreen,
              },
            );
            Navigator.of(context)
                .push<void>(MaterialPageRoute<void>(builder: builder))
                .then((_) => detailVm.reload());
          }

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground(context),
            appBar: AppBarWidget(
              title: detailTitle,
              showBackButton: true,
              centerTitle: true,
              xpIconSourceScreen: _kScenarioDetailScreenId,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
                AppSizes.horizontalPadding,
                AppSizes.spaceLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoleplayCefrLevelBar(
                    totalXp: detailVm.totalXp,
                    selectedLevel: level,
                    onLevelSelected: detailVm.selectLevel,
                    isLevelUnlocked: detailVm.isLevelUnlocked,
                    onLockedLevelTap: (ctx, lvl) => SnackbarHelper.showError(
                      ctx,
                      ctx.l10n.roleplayLevelLocked(
                        detailVm.xpRequiredForLevel(lvl),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.h(16)),
                  RoleplayScenarioOverviewCard(
                    scenario: scenario,
                    practiceTitle: RoleplayScenarioL10n.practiceTitle(
                      l10n,
                      scenario.id,
                    ),
                    levelCode: levelCode,
                    levelLabel: levelLabel,
                    progress: detailVm.moduleProgress,
                  ),
                  SizedBox(height: AppSizes.h(24)),
                  Text(
                    l10n.learnAndPractice,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(18),
                      fontWeight: FontWeight.w700,
                      color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  RoleplayPracticeOptionTile(
                    title: l10n.dialogue,
                    subtitle: l10n.roleplayDialogueSub,
                    xpLabel: l10n.roleplayXpPerLesson(
                      RoleplayXpRewards.dialogue,
                    ),
                    iconAsset: AppAssets.roleDialog,
                    iconBackgroundColor: AppColors.primaryColor,
                    onTap: () => openModule(
                      'dialogue',
                      'role_play_dialogue',
                      detailVm.dialogueModuleState,
                      (_) => RoleplayDialoguePathScreen(
                        scenarioId: scenario.id,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  RoleplayPracticeOptionTile(
                    title: l10n.vocabulary,
                    subtitle: RoleplayScenarioL10n.vocabularySubtitle(
                      l10n,
                      scenario.id,
                    ),
                    xpLabel: l10n.roleplayXpPerLesson(
                      RoleplayXpRewards.vocabulary,
                    ),
                    iconAsset: 'assets/svg/vocabulary_book.svg',
                    iconBackgroundColor: AppColors.primaryColor,
                    onTap: () => openModule(
                      'vocabulary',
                      'role_play_vocabulary',
                      detailVm.vocabularyModuleState,
                      (_) => RoleplayVocabularyPathScreen(
                        scenarioId: scenario.id,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.h(12)),
                  RoleplayPracticeOptionTile(
                    title: l10n.comprehension,
                    subtitle: l10n.roleplayComprehensionSub,
                    xpLabel: l10n.roleplayXpPerLesson(
                      RoleplayXpRewards.comprehension,
                    ),
                    iconBackgroundColor: AppColors.learnReadingOrange,
                    iconAsset: 'assets/svg/quick_che3ck.svg',
                    onTap: () => openModule(
                      'comprehension',
                      'role_play_comprehension',
                      detailVm.comprehensionModuleState,
                      (_) => RoleplayQuickCheckPathScreen(
                        scenarioId: scenario.id,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSm),

                ],
              ),
            ),
            bottomNavigationBar:   SafeArea(
              child: HomeBannerAd(
                placement: AdPlacement.roleplayDetailBanner,
                bottomPadding: AppSizes.spaceSm,
              ),
            ),
          );
        },
      ),
    );
  }
}
