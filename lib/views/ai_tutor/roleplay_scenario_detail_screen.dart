import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/l10n/roleplay_scenario_l10n.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/ai_tutor_view_model.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_practice_option_tile.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_scenario_overview_card.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';

class RoleplayScenarioDetailScreen extends StatelessWidget {
  const RoleplayScenarioDetailScreen({
    super.key,
    required this.scenarioId,
  });

  final String scenarioId;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final scenario = AiTutorViewModel.scenarioById(scenarioId);

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
            RoleplayScenarioOverviewCard(
              scenario: scenario,
              practiceTitle: RoleplayScenarioL10n.practiceTitle(l10n, scenario.id),
              levelCode: l10n.levelA1,
              levelLabel: l10n.levelBeginner,
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
              title: l10n.vocabulary,
              subtitle: RoleplayScenarioL10n.vocabularySubtitle(l10n, scenario.id),
              iconAsset: 'assets/svg/vocabulary_book.svg',
              iconBackgroundColor: AppColors.primaryColor,
              onTap: () => _showComingSoon(context),
            ),
            SizedBox(height: AppSizes.h(12)),
            RoleplayPracticeOptionTile(
              title: l10n.quickCheck,
              subtitle: l10n.quickCheckSub,
              iconBackgroundColor: AppColors.learnReadingOrange,
              iconAsset: 'assets/svg/quick_che3ck.svg',
              onTap: () => _showComingSoon(context),

            ),
            SizedBox(height: AppSizes.h(180)),
            const HomeBannerAd(),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    SnackbarHelper.showSuccess(context, context.l10n.openingSoon);
  }
}
