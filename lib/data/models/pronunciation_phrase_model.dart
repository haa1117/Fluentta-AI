class PronunciationWordFeedback {
  const PronunciationWordFeedback({
    required this.word,
    required this.confidence,
  });

  final String word;
  final int confidence;

  bool get isHighConfidence => confidence >= 85;
}

class PronunciationPhraseData {
  const PronunciationPhraseData({
    required this.phrase,
    required this.overallScore,
    required this.words,
  });

  final String phrase;
  final int overallScore;
  final List<PronunciationWordFeedback> words;
}

class PronunciationContent {
  PronunciationContent._();

  static const List<PronunciationPhraseData> phrases = [
    PronunciationPhraseData(
      phrase: 'Please check the report.',
      overallScore: 85,
      words: [
        PronunciationWordFeedback(word: 'Please', confidence: 90),
        PronunciationWordFeedback(word: 'check', confidence: 78),
        PronunciationWordFeedback(word: 'the', confidence: 95),
        PronunciationWordFeedback(word: 'report', confidence: 88),
      ],
    ),
    PronunciationPhraseData(
      phrase: 'I have a meeting.',
      overallScore: 88,
      words: [
        PronunciationWordFeedback(word: 'I', confidence: 90),
        PronunciationWordFeedback(word: 'have', confidence: 95),
        PronunciationWordFeedback(word: 'a', confidence: 88),
        PronunciationWordFeedback(word: 'meeting', confidence: 82),
      ],
    ),
    PronunciationPhraseData(
      phrase: 'Can we schedule a call?',
      overallScore: 82,
      words: [
        PronunciationWordFeedback(word: 'Can', confidence: 92),
        PronunciationWordFeedback(word: 'we', confidence: 88),
        PronunciationWordFeedback(word: 'schedule', confidence: 75),
        PronunciationWordFeedback(word: 'a', confidence: 90),
        PronunciationWordFeedback(word: 'call', confidence: 80),
      ],
    ),
    PronunciationPhraseData(
      phrase: 'The project is on track.',
      overallScore: 86,
      words: [
        PronunciationWordFeedback(word: 'The', confidence: 94),
        PronunciationWordFeedback(word: 'project', confidence: 80),
        PronunciationWordFeedback(word: 'is', confidence: 91),
        PronunciationWordFeedback(word: 'on', confidence: 87),
        PronunciationWordFeedback(word: 'track', confidence: 83),
      ],
    ),
    PronunciationPhraseData(
      phrase: 'Thank you for your help.',
      overallScore: 90,
      words: [
        PronunciationWordFeedback(word: 'Thank', confidence: 93),
        PronunciationWordFeedback(word: 'you', confidence: 96),
        PronunciationWordFeedback(word: 'for', confidence: 89),
        PronunciationWordFeedback(word: 'your', confidence: 88),
        PronunciationWordFeedback(word: 'help', confidence: 91),
      ],
    ),
  ];
}
