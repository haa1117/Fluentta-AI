import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/data/models/onboarding_page_model.dart';
import 'package:fluentta_ai/data/models/setup_option_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class LocalizedContent {
  LocalizedContent._();

  static List<OnboardingPageModel> onboardingPages(AppLocalizations l10n) {
    return [
      OnboardingPageModel(
        imagePath: AppAssets.onboarding1,
        title: l10n.onboardingTitle1,
        description: l10n.onboardingDesc1,
      ),
      OnboardingPageModel(
        imagePath: AppAssets.onboarding2,
        title: l10n.onboardingTitle2,
        description: l10n.onboardingDesc2,
      ),
      OnboardingPageModel(
        imagePath: AppAssets.onboarding3,
        title: l10n.onboardingTitle3,
        description: l10n.onboardingDesc3,
      ),
    ];
  }

  static String setupTitle(AppLocalizations l10n, int step) {
    return switch (step) {
      0 => l10n.setupGoalTitle,
      1 => l10n.setupLevelTitle,
      2 => l10n.setupDailyTitle,
      _ => '',
    };
  }

  static String setupSubtitle(AppLocalizations l10n, int step) {
    return switch (step) {
      0 => l10n.setupGoalSubtitle,
      1 => l10n.setupLevelSubtitle,
      2 => l10n.setupDailySubtitle,
      _ => '',
    };
  }

  static List<SetupOptionModel> setupOptions(AppLocalizations l10n, int step) {
    return switch (step) {
      0 => [
          SetupOptionModel(
            id: 'travel',
            title: l10n.goalTravel,
            subtitle: l10n.goalTravelSub,
            svgIcon: 'assets/svg/flight.svg',
          ),
          SetupOptionModel(
            id: 'work',
            title: l10n.goalWork,
            subtitle: l10n.goalWorkSub,
            svgIcon: 'assets/svg/WORK.svg',
          ),
          SetupOptionModel(
            id: 'exam',
            title: l10n.goalExam,
            subtitle: l10n.goalExamSub,
            svgIcon: 'assets/svg/EXAM.svg',
          ),
          SetupOptionModel(
            id: 'everyday',
            title: l10n.goalEveryday,
            subtitle: l10n.goalEverydaySub,
            svgIcon: 'assets/svg/flight.svg',
          ),
        ],
      1 => [
          SetupOptionModel(
            id: 'beginner',
            title: l10n.levelBeginner,
            subtitle: l10n.levelBeginnerSub,
            svgIcon: 'assets/svg/beginner.svg',
          ),
          SetupOptionModel(
            id: 'elementary',
            title: l10n.levelElementary,
            subtitle: l10n.levelElementarySub,
            svgIcon: 'assets/svg/elementary.svg',
          ),
          SetupOptionModel(
            id: 'intermediate',
            title: l10n.levelIntermediate,
            subtitle: l10n.levelIntermediateSub,
            svgIcon: 'assets/svg/intermediatate.svg',
          ),
          SetupOptionModel(
            id: 'upper_intermediate',
            title: l10n.levelUpperIntermediate,
            subtitle: l10n.levelUpperIntermediateSub,
            svgIcon: 'assets/svg/rocket.svg',
          ),
          SetupOptionModel(
            id: 'advanced_c1',
            title: l10n.levelAdvancedC1,
            subtitle: l10n.levelAdvancedC1Sub,
            svgIcon: 'assets/svg/rocket.svg',
          ),
          SetupOptionModel(
            id: 'proficient_c2',
            title: l10n.levelProficientC2,
            subtitle: l10n.levelProficientC2Sub,
            svgIcon: 'assets/svg/rocket.svg',
          ),
        ],
      2 => [
          SetupOptionModel(
            id: '5',
            title: l10n.daily5,
            subtitle: l10n.daily5Sub,
            svgIcon: 'assets/svg/time.svg',
          ),
          SetupOptionModel(
            id: '10',
            title: l10n.daily10,
            subtitle: l10n.daily10Sub,
            svgIcon: 'assets/svg/time.svg',
          ),
          SetupOptionModel(
            id: '15',
            title: l10n.daily15,
            subtitle: l10n.daily15Sub,
            svgIcon: 'assets/svg/time.svg',
          ),
          SetupOptionModel(
            id: '20',
            title: l10n.daily20,
            subtitle: l10n.daily20Sub,
            svgIcon: 'assets/svg/time.svg',
          ),
        ],
      _ => const [],
    };
  }

  static String levelCode(AppLocalizations l10n, String? englishLevel) {
    return switch (englishLevel) {
      'elementary' => l10n.levelA2,
      'intermediate' => l10n.levelB1,
      'upper_intermediate' => l10n.levelB2,
      'advanced' => l10n.levelB2,
      'advanced_c1' => l10n.levelC1,
      'proficient_c2' => l10n.levelC2,
      _ => l10n.levelA1,
    };
  }
}
