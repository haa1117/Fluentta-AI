/// Remote-controlled ad slots. Add new values here when wiring more screens.
enum AdPlacement {
  onboardingNative('onboarding_native'),
  languageNative('language_native'),
  splashInterstitial('splash_interstitial'),
  homeBanner('home_banner'),
  learnBanner('learn_banner'),
  setupBanner('setup_banner'),
  roleplayBanner('roleplay_banner'),
  roleplayDetailBanner('roleplay_detail_banner'),
  lessonNative('lesson_native'),
  rewardedXpBoost('rewarded_xp_boost');

  const AdPlacement(this.firestoreKey);

  final String firestoreKey;

  bool get isBanner =>
      this == AdPlacement.homeBanner ||
      this == AdPlacement.learnBanner ||
      this == AdPlacement.setupBanner ||
      this == AdPlacement.roleplayBanner ||
      this == AdPlacement.roleplayDetailBanner;

  bool get isNative =>
      this == AdPlacement.onboardingNative ||
      this == AdPlacement.languageNative ||
      this == AdPlacement.lessonNative;

  bool get isInterstitial => this == AdPlacement.splashInterstitial;

  bool get isRewarded => this == AdPlacement.rewardedXpBoost;
}
