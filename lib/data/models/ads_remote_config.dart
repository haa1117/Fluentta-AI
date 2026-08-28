import 'package:fluentta_ai/core/ads/ad_placement.dart';

class AdPlacementSettings {
  const AdPlacementSettings({
    required this.enabled,
    required this.showRate,
    required this.minIntervalSeconds,
  });

  final bool enabled;
  final double showRate;
  final int minIntervalSeconds;

  factory AdPlacementSettings.defaults({bool enabled = false}) {
    return AdPlacementSettings(
      enabled: enabled,
      showRate: 1,
      minIntervalSeconds: 0,
    );
  }

  factory AdPlacementSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return AdPlacementSettings.defaults();
    return AdPlacementSettings(
      enabled: map['enabled'] as bool? ?? false,
      showRate: _readRate(map['showRate']),
      minIntervalSeconds: (map['minIntervalSeconds'] as num?)?.toInt() ?? 0,
    );
  }

  static double _readRate(Object? value) {
    if (value is num) return value.clamp(0, 1).toDouble();
    return 1;
  }
}

class AdsRemoteConfig {
  const AdsRemoteConfig({
    required this.masterEnabled,
    required this.hideForPremiumUsers,
    required this.placements,
  });

  final bool masterEnabled;
  final bool hideForPremiumUsers;
  final Map<AdPlacement, AdPlacementSettings> placements;

  static AdsRemoteConfig defaults() {
    return AdsRemoteConfig(
      masterEnabled: true,
      hideForPremiumUsers: true,
      placements: {
        for (final placement in AdPlacement.values)
          placement: AdPlacementSettings.defaults(
            enabled: placement == AdPlacement.onboardingNative,
          ),
      },
    );
  }

  factory AdsRemoteConfig.fromFirestore(Map<String, dynamic>? data) {
    final defaults = AdsRemoteConfig.defaults();
    if (data == null) return defaults;

    final placementMaps =
        data['placements'] as Map<String, dynamic>? ?? const {};
    final placements = Map<AdPlacement, AdPlacementSettings>.from(
      defaults.placements,
    );

    for (final placement in AdPlacement.values) {
      final raw = placementMaps[placement.firestoreKey];
      if (raw is! Map<String, dynamic>) continue;

      final parsed = AdPlacementSettings.fromMap(raw);
      final base = placements[placement]!;
      placements[placement] = AdPlacementSettings(
        enabled: raw.containsKey('enabled') ? parsed.enabled : base.enabled,
        showRate: raw.containsKey('showRate') ? parsed.showRate : base.showRate,
        minIntervalSeconds: raw.containsKey('minIntervalSeconds')
            ? parsed.minIntervalSeconds
            : base.minIntervalSeconds,
      );
    }

    return AdsRemoteConfig(
      masterEnabled: data.containsKey('masterEnabled')
          ? (data['masterEnabled'] as bool? ?? true)
          : defaults.masterEnabled,
      hideForPremiumUsers: data.containsKey('hideForPremiumUsers')
          ? (data['hideForPremiumUsers'] as bool? ?? true)
          : defaults.hideForPremiumUsers,
      placements: placements,
    );
  }

  AdPlacementSettings settingsFor(AdPlacement placement) {
    return placements[placement] ?? AdPlacementSettings.defaults();
  }
}
