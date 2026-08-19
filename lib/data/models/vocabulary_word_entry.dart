import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';

class VocabularyWordEntry {
  const VocabularyWordEntry({
    required this.id,
    required this.lessonId,
    required this.cefrLevel,
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.example,
    this.partOfSpeech,
  });

  final String id;
  final String lessonId;
  final String cefrLevel;
  final String word;
  final String phonetic;
  final String meaning;
  final String example;
  final String? partOfSpeech;

  static String buildId(String lessonId, String word) {
    final normalized = word.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    return '${lessonId}_$normalized';
  }

  factory VocabularyWordEntry.fromWord({
    required String lessonId,
    required String cefrLevel,
    required VocabularyWordModel wordModel,
  }) {
    return VocabularyWordEntry(
      id: buildId(lessonId, wordModel.word),
      lessonId: lessonId,
      cefrLevel: cefrLevel,
      word: wordModel.word,
      phonetic: wordModel.phonetic,
      meaning: wordModel.meaning,
      example: wordModel.example,
      partOfSpeech: wordModel.partOfSpeech,
    );
  }

  VocabularyWordModel toWordModel() {
    return VocabularyWordModel(
      word: word,
      phonetic: phonetic,
      meaning: meaning,
      example: example,
      partOfSpeech: partOfSpeech,
    );
  }

  factory VocabularyWordEntry.fromJson(Map<String, dynamic> json) {
    return VocabularyWordEntry(
      id: json['id'] as String,
      lessonId: json['lessonId'] as String,
      cefrLevel: json['cefrLevel'] as String,
      word: json['word'] as String,
      phonetic: json['phonetic'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String,
      partOfSpeech: json['partOfSpeech'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'cefrLevel': cefrLevel,
      'word': word,
      'phonetic': phonetic,
      'meaning': meaning,
      'example': example,
      if (partOfSpeech != null) 'partOfSpeech': partOfSpeech,
    };
  }
}
