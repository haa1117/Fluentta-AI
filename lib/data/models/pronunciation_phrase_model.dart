class PronunciationWordFeedback {
  const PronunciationWordFeedback({
    required this.word,
    required this.confidence,
    this.spokenWord,
    this.weakSounds = const [],
    this.weakCharIndices = const [],
  });

  factory PronunciationWordFeedback.fromJson(Map<String, dynamic> json) {
    final indices = json['weakCharIndices'];
    final sounds = json['weakSounds'];
    return PronunciationWordFeedback(
      word: json['word'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.round().clamp(0, 100) ?? 0,
      spokenWord: json['spokenWord'] as String?,
      weakSounds: sounds is List
          ? sounds.map((sound) => sound.toString()).toList()
          : const [],
      weakCharIndices: indices is List
          ? indices.map((index) => (index as num).round()).toList()
          : const [],
    );
  }

  final String word;
  final int confidence;
  final String? spokenWord;
  final List<String> weakSounds;
  final List<int> weakCharIndices;

  bool get isHighConfidence => confidence >= 85;
  bool get needsPractice => !isHighConfidence;
}

class PronunciationAssessmentResult {
  const PronunciationAssessmentResult({
    required this.overallScore,
    required this.words,
    required this.transcript,
    this.heardAnything = true,
  });

  final int overallScore;
  final List<PronunciationWordFeedback> words;
  final String transcript;
  final bool heardAnything;

  factory PronunciationAssessmentResult.fromJson(Map<String, dynamic> json) {
    final rawWords = json['words'];
    return PronunciationAssessmentResult(
      overallScore: (json['overallScore'] as num?)?.round().clamp(0, 100) ?? 0,
      words: rawWords is List
          ? rawWords
              .whereType<Map>()
              .map(
                (word) => PronunciationWordFeedback.fromJson(
                  Map<String, dynamic>.from(word),
                ),
              )
              .toList()
          : const [],
      transcript: json['transcript'] as String? ?? '',
      heardAnything: json['heardAnything'] as bool? ?? true,
    );
  }

  /// Words flagged for practice, or one session when feedback shows room to improve.
  int get correctionCount {
    if (words.isEmpty) {
      return heardAnything ? 0 : 1;
    }

    final needsPracticeCount =
        words.where((word) => word.needsPractice).length;
    if (needsPracticeCount > 0) return needsPracticeCount;

    if (overallScore < 100) return 1;
    return 0;
  }
}

class PronunciationPhrase {
  const PronunciationPhrase({required this.text});

  final String text;
}

class PronunciationContent {
  PronunciationContent._();

  static const List<PronunciationPhrase> phrases = [
    PronunciationPhrase(text: 'Please check the report.'),
    PronunciationPhrase(text: 'I have a meeting.'),
    PronunciationPhrase(text: 'Can we schedule a call?'),
    PronunciationPhrase(text: 'The project is on track.'),
    PronunciationPhrase(text: 'Thank you for your help.'),
  ];
}
