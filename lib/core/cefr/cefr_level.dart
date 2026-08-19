enum CefrLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2;

  String get code => name.toUpperCase();

  String get assetFolder => name;

  static CefrLevel fromCode(String code) {
    return CefrLevel.values.firstWhere(
      (level) => level.code == code.toUpperCase(),
      orElse: () => CefrLevel.a1,
    );
  }

  static CefrLevel fromSetupId(String? setupId) {
    return switch (setupId) {
      'elementary' => CefrLevel.a2,
      'intermediate' => CefrLevel.b1,
      'upper_intermediate' => CefrLevel.b2,
      'advanced' => CefrLevel.b2,
      'advanced_c1' => CefrLevel.c1,
      'proficient_c2' => CefrLevel.c2,
      _ => CefrLevel.a1,
    };
  }

  static String setupIdFor(CefrLevel level) {
    return switch (level) {
      CefrLevel.a1 => 'beginner',
      CefrLevel.a2 => 'elementary',
      CefrLevel.b1 => 'intermediate',
      CefrLevel.b2 => 'upper_intermediate',
      CefrLevel.c1 => 'advanced_c1',
      CefrLevel.c2 => 'proficient_c2',
    };
  }
}
