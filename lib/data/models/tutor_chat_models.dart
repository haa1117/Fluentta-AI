class TutorChatTurn {
  const TutorChatTurn({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;

  Map<String, String> toJson() => {
        'role': role,
        'content': content,
      };
}

class TutorChatResponse {
  const TutorChatResponse({
    required this.tutorReply,
    required this.correctedText,
    required this.explanation,
    required this.isCorrect,
  });

  final String tutorReply;
  final String correctedText;
  final String explanation;
  final bool isCorrect;

  factory TutorChatResponse.fromJson(Map<String, dynamic> json) {
    return TutorChatResponse(
      tutorReply: (json['tutorReply'] as String? ?? '').trim(),
      correctedText: (json['correctedText'] as String? ?? '').trim(),
      explanation: (json['explanation'] as String? ?? '').trim(),
      isCorrect: json['isCorrect'] == true,
    );
  }
}

class OpenChatMessage {
  const OpenChatMessage({
    required this.isUser,
    required this.text,
    this.correctedText,
    this.explanation,
    this.isCorrect = true,
    this.sequence,
  });

  final bool isUser;
  final String text;
  final String? correctedText;
  final String? explanation;
  final bool isCorrect;

  /// The `message_sequence` analytics id of the conversational turn this
  /// message belongs to (same value on the user message and the AI reply it
  /// produced). Null for the initial greeting, which isn't a real turn.
  final int? sequence;
}
