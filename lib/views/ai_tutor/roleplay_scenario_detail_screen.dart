import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
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

class RoleplayScenarioDetailScreen extends StatelessWidget {
  const RoleplayScenarioDetailScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final scenario = AiTutorViewModel.scenarioById(scenarioId);

    if (scenario != null &&
        !context.read<EntitlementsService>().canAccessRoleplayScenario(
          scenario.id,
        )) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        showProFeatureSheet(
          context,
          title: 'Advanced Roleplay',
          message: 'Upgrade to Pro to unlock all roleplay scenarios.',
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
        body: const Center(child: Text('Scenario not found')),
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
              backgroundColor: AppColors.scaffoldBackgroundColor,
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

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackgroundColor,
            appBar: AppBarWidget(
              title: detailTitle,
              showBackButton: true,
              centerTitle: true,
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
                      color: AppColors.textPrimary,
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
                    onTap: () {
                      Navigator.of(context)
                          .push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => RoleplayDialoguePathScreen(
                                scenarioId: scenario.id,
                              ),
                            ),
                          )
                          .then((_) => detailVm.reload());
                    },
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
                    onTap: () {
                      Navigator.of(context)
                          .push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => RoleplayVocabularyPathScreen(
                                scenarioId: scenario.id,
                              ),
                            ),
                          )
                          .then((_) => detailVm.reload());
                    },
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
                    onTap: () {
                      Navigator.of(context)
                          .push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => RoleplayQuickCheckPathScreen(
                                scenarioId: scenario.id,
                              ),
                            ),
                          )
                          .then((_) => detailVm.reload());
                    },
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
