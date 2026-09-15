import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentta_ai/core/constants/ai_backend_config.dart';
import 'package:fluentta_ai/data/models/tutor_chat_models.dart';
import 'package:http/http.dart' as http;

class AiBackendException implements Exception {
  AiBackendException(this.message);
  final String message;

  @override
  String toString() => message;
}

class AiBackendService {
  AiBackendService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> _idToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw AiBackendException('Sign in to use AI features.');
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw AiBackendException('Could not get auth token.');
    }
    return token;
  }

  Future<Map<String, dynamic>> _postJson({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final token = await _idToken();
    final response = await _client
        .post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 60));

    Map<String, dynamic> decoded = {};
    if (response.body.isNotEmpty) {
      final parsed = jsonDecode(response.body);
      if (parsed is Map<String, dynamic>) {
        decoded = parsed;
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AiBackendException(
        decoded['error'] as String? ??
            'AI request failed (${response.statusCode})',
      );
    }
    return decoded;
  }

  /// Open-ended English practice chat. Fluenta's roleplay scenarios do not use
  /// this endpoint — they run off bundled content.
  Future<TutorChatResponse> tutorChat({
    required String userText,
    List<TutorChatTurn> history = const [],
    String? cefrLevel,
    String? goal,
  }) async {
    final json = await _postJson(
      url: AiBackendConfig.tutorChatUrl,
      body: {
        'userText': userText,
        'history': history.map((turn) => turn.toJson()).toList(),
        if (cefrLevel != null && cefrLevel.isNotEmpty) 'cefrLevel': cefrLevel,
        if (goal != null && goal.isNotEmpty) 'goal': goal,
      },
    );
    return TutorChatResponse.fromJson(json);
  }

  Future<String> transcribePronunciation({
    required Uint8List audioBytes,
    required String mimeType,
    required String filename,
    required String expectedPhrase,
  }) async {
    final json = await _postJson(
      url: AiBackendConfig.assessPronunciationUrl,
      body: {
        'audioBase64': base64Encode(audioBytes),
        'mimeType': mimeType,
        'filename': filename,
        'expectedPhrase': expectedPhrase,
      },
    );
    return (json['transcript'] as String? ?? '').trim();
  }

  /// Free-form speech-to-text for the chat's voice mode. Uses a
  /// conversational transcription model that handles accents well.
  Future<String> transcribeSpeech({
    required Uint8List audioBytes,
    required String mimeType,
    required String filename,
  }) async {
    final json = await _postJson(
      url: AiBackendConfig.transcribeUrl,
      body: {
        'audioBase64': base64Encode(audioBytes),
        'mimeType': mimeType,
        'filename': filename,
      },
    );
    return (json['transcript'] as String? ?? '').trim();
  }
}
