class AiBackendConfig {
  AiBackendConfig._();

  static const String region = 'us-central1';
  static const String projectId = 'fluenttaai';

  static const String tutorChatUrl =
      'https://$region-$projectId.cloudfunctions.net/tutorChat';
  static const String assessPronunciationUrl =
      'https://$region-$projectId.cloudfunctions.net/assessPronunciation';
  static const String transcribeUrl =
      'https://$region-$projectId.cloudfunctions.net/transcribe';
  static const String translateVocabularyUrl =
      'https://$region-$projectId.cloudfunctions.net/translateVocabulary';
}
