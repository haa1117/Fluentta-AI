enum LessonType {
  vocabulary,
  grammar,
  reading;

  String get id => name;

  String get assetFolder => name;

  static LessonType fromId(String id) {
    return LessonType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => LessonType.vocabulary,
    );
  }
}
