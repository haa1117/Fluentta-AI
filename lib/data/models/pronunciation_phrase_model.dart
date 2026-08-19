class PronunciationWordFeedback {
  const PronunciationWordFeedback({
    required this.word,
    required this.confidence,
    this.spokenWord,
    this.weakSounds = const [],
    this.weakCharIndices = const [],
  });

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
