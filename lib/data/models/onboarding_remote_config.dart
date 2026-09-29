class OnboardingRemoteConfig {
  const OnboardingRemoteConfig({
    required this.enabled,
    required this.onboardingFlowId,
    required this.experimentId,
    required this.variantId,
    required this.configSource,
  });

  /// Single switch for the whole 3-page carousel (Meet Your AI English
  /// Tutor / Get Instant Corrections / Improve Every Day) — not per-step.
  final bool enabled;
  final String onboardingFlowId;
  final String experimentId;
  final String variantId;
  final String configSource; // 'remote_config' | 'local_default'

  static OnboardingRemoteConfig defaults() {
    return const OnboardingRemoteConfig(
      enabled: true,
      onboardingFlowId: 'intro_control_v1',
      experimentId: 'none',
      variantId: 'none',
      configSource: 'local_default',
    );
  }

  factory OnboardingRemoteConfig.fromFirestore(Map<String, dynamic>? data) {
    final defaults = OnboardingRemoteConfig.defaults();
    if (data == null) return defaults;

    return OnboardingRemoteConfig(
      enabled: data['enabled'] as bool? ?? defaults.enabled,
      onboardingFlowId:
          data['onboardingFlowId'] as String? ?? defaults.onboardingFlowId,
      experimentId: data['experimentId'] as String? ?? defaults.experimentId,
      variantId: data['variantId'] as String? ?? defaults.variantId,
      configSource: 'remote_config',
    );
  }
}
