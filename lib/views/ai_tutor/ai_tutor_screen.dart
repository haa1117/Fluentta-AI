import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/roleplay_scenario_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/ai_tutor_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/chat/open_chat_practice_screen.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_scenario_card.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AiTutorScreen extends StatelessWidget {
  const AiTutorScreen({super.key});

  static String scenarioTitle(AppLocalizations l10n, String id) {
    return switch (id) {
      'job_interviews' => l10n.scenarioJobInterviews,
      'order_food' => l10n.scenarioOrderFood,
      'at_airport' => l10n.scenarioAtAirport,
      'doctor_visit' => l10n.scenarioDoctorVisit,
      'small_talk' => l10n.scenarioSmallTalk,
      'business_meeting' => l10n.scenarioBusinessMeeting,
      _ => id,
    };
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<AiTutorViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.aiTutor,
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceMd),
            Container(
              width: AppSizes.w(140),
              height: AppSizes.w(140),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.homeCardLavender,
              ),
              child: ClipOval(
                child: Image.asset(AppAssets.aiTutor, fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
            Text(
              l10n.howToPracticeToday,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(24),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
            _OpenAiChatCard(
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const OpenChatPracticeScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: AppSizes.spaceXl),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.roleplayScenarios,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            SizedBox(
              height: AppSizes.w(130) + AppSizes.h(44),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AiTutorViewModel.scenarios.length,
                separatorBuilder: (_, index) => SizedBox(width: AppSizes.w(12)),
                itemBuilder: (context, index) {
                  final scenario = AiTutorViewModel.scenarios[index];
                  final title = scenarioTitle(l10n, scenario.id);
                  return RoleplayScenarioCard(
                    scenario: RoleplayScenarioModel(
                      id: scenario.id,
                      title: title,
                      icon: scenario.icon,
                      imagePath: scenario.imagePath,
                    ),
                    isSelected: viewModel.selectedScenarioId == scenario.id,
                    onTap: () {
                      viewModel.selectScenario(scenario.id);
                      SnackbarHelper.showSuccess(
                        context,
                        l10n.selectedScenario(title),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: AppSizes.spaceXxl),
          ],
        ),
      ),
    );
  }

  static Future<void> open(BuildContext context) async {
    if (!context.mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AiTutorViewModel(context.read<HomeViewModel>()),
          child: const AiTutorScreen(),
        ),
      ),
    );
  }
}

class _OpenAiChatCard extends StatelessWidget {
  const _OpenAiChatCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.w(16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/svg/ai_chat.svg',
              // color: AppColors.primaryColor,
              width: AppSizes.sp(48),
              height: AppSizes.sp(48) ,
            ),
            SizedBox(width: AppSizes.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.openAiChatPractice,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      fontWeight: FontWeight.w700,
                      color:Color(0xff665D72),
                    ),
                  ),
                  SizedBox(height: AppSizes.h(6)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(10),
                      vertical: AppSizes.h(3),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(AppSizes.w(20)),
                    ),
                    child: Text(
                      l10n.openingSoon,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: AppSizes.sp(22),
            ),
          ],
        ),
      ),
    );
  }
}
