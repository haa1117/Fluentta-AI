class LanguageModel {
  const LanguageModel({
    required this.code,
    required this.name,
    required this.flagEmoji,
    this.subtitle,
    this.isSuggested = false,
  });

  final String code;
  final String name;
  final String flagEmoji;
  final String? subtitle;
  final bool isSuggested;
}
