/// Remote-controlled ad slots. Add new values here when wiring more screens.
enum AdPlacement {
  onboardingNative('onboarding_native'),
  homeBanner('home_banner'),
  learnBanner('learn_banner'),
  setupBanner('setup_banner'),
  roleplayBanner('roleplay_banner'),
  lessonNative('lesson_native'),
  rewardedXpBoost('rewarded_xp_boost');

  const AdPlacement(this.firestoreKey);

  final String firestoreKey;

  bool get isBanner =>
      this == AdPlacement.homeBanner ||
      this == AdPlacement.learnBanner ||
      this == AdPlacement.setupBanner ||
      this == AdPlacement.roleplayBanner;

  bool get isNative =>
      this == AdPlacement.onboardingNative ||
      this == AdPlacement.lessonNative;

  bool get isRewarded => this == AdPlacement.rewardedXpBoost;
}
