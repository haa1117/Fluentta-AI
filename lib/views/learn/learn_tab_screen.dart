import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/analytics_user_properties.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:fluentta_ai/widgets/common/cefr_level_bar.dart';
import 'package:fluentta_ai/widgets/learn/learn_category_card.dart';
import 'package:fluentta_ai/widgets/learn/learn_level_card.dart';
import 'package:provider/provider.dart';

class LearnTabScreen extends StatefulWidget {
  const LearnTabScreen({super.key});

  @override
  State<LearnTabScreen> createState() => _LearnTabScreenState();
}

class _LearnTabScreenState extends State<LearnTabScreen> {
  bool _loggedViewed = false;

  static const _destinationForModule = {
    'vocabulary': 'cefr_vocabulary',
    'grammar': 'cefr_grammar',
    'reading': 'cefr_reading',
  };

  void _logLearnViewed(LearnViewModel learnViewModel) {
    if (_loggedViewed) return;
    _loggedViewed = true;
    AnalyticsService.instance.logScreenView('learn');
    AnalyticsUserProperties.sync(
      context.read<LocalStorage>(),
      user: context.read<AuthRepository>().currentUser,
      currentCefrLevel: learnViewModel.currentProgressLevel.name,
    );
    AnalyticsService.instance.log(AnalyticsEvents.learnViewed, {
      // Learn is only reachable via the bottom nav today — no in-app deep
      // link or app-open router lands here directly.
      AnalyticsParams.entrySource: 'bottom_nav',
      AnalyticsParams.currentCefrLevel:
          learnViewModel.currentProgressLevel.code,
      AnalyticsParams.selectedCefrLevel: learnViewModel.selectedLevel.code,
      AnalyticsParams.currentXp: learnViewModel.totalXp,
      AnalyticsParams.subscriptionTierAtEvent: learnViewModel.subscriptionTier,
    });
  }

  void _logCefrLevelClicked(
    LearnViewModel learnViewModel,
    CefrLevel level, {
    required String levelAccess,
    int? xpRequired,
  }) {
    AnalyticsService.instance.log(AnalyticsEvents.cefrLevelClicked, {
      AnalyticsParams.cefrLevel: level.code,
      AnalyticsParams.levelAccess: levelAccess,
      AnalyticsParams.currentXp: learnViewModel.totalXp,
      AnalyticsParams.xpRequired: xpRequired,
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final learnViewModel = context.watch<LearnViewModel>();
    context.watch<HomeViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _logLearnViewed(learnViewModel);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.learnAndGrow,
        showActionButton: true,
        xpIconSourceScreen: 'learn',
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
            CefrLevelBar(
              totalXp: learnViewModel.totalXp,
              selectedLevel: learnViewModel.selectedLevel,
              onLevelSelected: (level) {
                _logCefrLevelClicked(
                  learnViewModel,
                  level,
                  levelAccess: level == learnViewModel.selectedLevel
                      ? 'current'
                      : 'unlocked',
                );
                learnViewModel.selectLevel(level);
              },
              isLevelUnlocked: learnViewModel.isLevelUnlocked,
              onLockedLevelTap: (ctx, level) {
                _logCefrLevelClicked(
                  learnViewModel,
                  level,
                  levelAccess: 'locked',
                  xpRequired: CefrLevelProgress.xpRequiredFor(level),
                );
                final prev = CefrLevelProgress.previousLevel(level);
                final remaining = prev == null
                    ? 0
                    : learnViewModel.coreLessonsRemaining(prev);
                SnackbarHelper.showError(
                  ctx,
                  remaining > 0
                      ? ctx.l10n.cefrLevelLockedLessons(remaining)
                      : ctx.l10n.cefrLevelLockedXp(
                          CefrLevelProgress.xpRequiredFor(level),
                        ),
                );
              },
            ),
            SizedBox(height: AppSizes.spaceMd),
            LearnLevelCard(isDark: isDark),
            SizedBox(height: AppSizes.spaceMd),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.spaceMd,
                crossAxisSpacing: AppSizes.spaceMd,
                childAspectRatio: 1.05,
              ),
              itemCount: learnViewModel.categories.length,
              itemBuilder: (context, index) {
                final category = learnViewModel.categories[index];
                return LearnCategoryCard(
                  isDark: isDark,
                  category: category,
                  onTap: () {
                    final destination = _destinationForModule[category.id];
                    if (destination != null) {
                      AnalyticsService.instance.log(
                        AnalyticsEvents.cefrModuleClicked,
                        {
                          AnalyticsParams.selectedCefrLevel:
                              learnViewModel.selectedLevel.name,
                          AnalyticsParams.moduleType: category.id,
                          AnalyticsParams.moduleState:
                              learnViewModel.moduleState(category.id),
                          AnalyticsParams.sourceScreen: 'learn',
                          AnalyticsParams.destinationScreen: destination,
                        },
                      );
                    } else if (category.id == 'saved_words') {
                      AnalyticsService.instance.log(
                        AnalyticsEvents.savedWordsClicked,
                        {
                          AnalyticsParams.sourceScreen: 'learn',
                          AnalyticsParams.destinationScreen: 'saved_words',
                        },
                      );
                    }
                    learnViewModel.openCategory(context, category);
                  },
                );
              },
            ),
            SizedBox(height: AppSizes.spaceSm),

          ],
        ),
      ),
      bottomNavigationBar:    HomeBannerAd(placement: AdPlacement.learnBanner,
      bottomPadding: AppSizes.spaceSm,
      ),
    );
  }
}
