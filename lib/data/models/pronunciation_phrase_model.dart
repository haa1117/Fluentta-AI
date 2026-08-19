class PronunciationWordFeedback {
  const PronunciationWordFeedback({
    required this.word,
    required this.confidence,
  });

  final String word;
  final int confidence;

  bool get isHighConfidence => confidence >= 85;
}

class PronunciationAssessmentResult {
  const PronunciationAssessmentResult({
    required this.overallScore,
    required this.words,
    required this.transcript,
  });

  final int overallScore;
  final List<PronunciationWordFeedback> words;
  final String transcript;
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
