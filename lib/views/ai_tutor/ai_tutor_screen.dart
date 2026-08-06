import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter/material.dart';import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/ai_tutor_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/widgets/ai_tutor/open_chat_practice_card.dart';import 'package:fluentta_ai/widgets/ai_tutor/roleplay_scenario_card.dart';
import 'package:provider/provider.dart';

class AiTutorScreen extends StatelessWidget {
  const AiTutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<AiTutorViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: 'AI Tutor',
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.homeCardLavender,
                // border: Border.all(
                //   color: AppColors.borderLight,
                //   width: 2,
                // ),
              ),
              child: ClipOval(
                child: Image.asset(
                  AppAssets.aiTutor,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
            Text(
              'How do you want to\npractice today?',
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
            OpenChatPracticeCard(
              onTap: () {
                SnackbarHelper.showSuccess(
                  context,
                  'Opening chat practice...',
                );
              },
            ),
            SizedBox(height: AppSizes.spaceXl),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Roleplay Scenarios',
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
                separatorBuilder: (context, index) =>
                    SizedBox(width: AppSizes.w(12)),
                itemBuilder: (context, index) {
                  final scenario = AiTutorViewModel.scenarios[index];
                  return RoleplayScenarioCard(
                    scenario: scenario,
                    isSelected: viewModel.selectedScenarioId == scenario.id,
                    onTap: () {
                      viewModel.selectScenario(scenario.id);
                      SnackbarHelper.showSuccess(
                        context,
                        'Selected: ${scenario.title}',
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
    final homeViewModel = context.read<HomeViewModel>();
    await homeViewModel.startAiChat(() {});

    if (!context.mounted) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => AiTutorViewModel(homeViewModel),
          child: const AiTutorScreen(),
        ),
      ),
    );  }
}
