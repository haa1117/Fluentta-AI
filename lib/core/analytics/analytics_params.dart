/// Parameter key constants for GA4 events, per the Fluenta Analytics Event
/// Catalogue. Keeps call sites free of typo'd string literals.
class AnalyticsParams {
  AnalyticsParams._();

  static const sourceScreen = 'source_screen';
  static const appName = 'app_name';
  static const tutorialStep = 'tutorial_step';
  static const tutorialStepName = 'tutorial_step_name';
  static const destinationScreen = 'destination_screen';
  static const sourceModal = 'source_modal';
  static const learningArea = 'learning_area';
  static const moduleType = 'module_type';
  static const cefrLevel = 'cefr_level';
  static const selectedCefrLevel = 'selected_cefr_level';
  static const currentCefrLevel = 'current_cefr_level';
  static const scenarioId = 'scenario_id';
  static const scenarioState = 'scenario_state';
  static const scenarioProgressPercent = 'scenario_progress_percent';
  static const completedModuleCount = 'completed_module_count';
  static const lessonId = 'lesson_id';
  static const lessonNumber = 'lesson_number';
  static const lessonState = 'lesson_state';
  static const entryAction = 'entry_action';
  static const lessonAttemptId = 'lesson_attempt_id';
  static const conversationId = 'conversation_id';
  static const conversionJourneyId = 'conversion_journey_id';
  static const recoveryJourneyId = 'recovery_journey_id';
  static const subscriptionTierAtEvent = 'subscription_tier_at_event';
  static const networkStatus = 'network_status';
  static const errorType = 'error_type';
  static const errorCode = 'error_code';
  static const configSource = 'config_source';
  static const experimentId = 'experiment_id';
  static const variantId = 'variant_id';
  static const failureStage = 'failure_stage';
  static const failedRule = 'failed_rule';

  // Splash
  static const appVersion = 'app_version';
  static const launchType = 'launch_type';
  static const durationMs = 'duration_ms';

  // Pre-login
  static const stepId = 'step_id';
  static const stepNumber = 'step_number';
  static const totalSteps = 'total_steps';
  static const onboardingFlowId = 'onboarding_flow_id';
  static const fromStep = 'from_step';
  static const toStep = 'to_step';

  // Language
  static const recommendationState = 'recommendation_state';
  static const recommendedLanguageCode = 'recommended_language_code';
  static const availableLanguageCount = 'available_language_count';
  static const languageCode = 'language_code';
  static const selectionSource = 'selection_source';
  static const recommendationMatch = 'recommendation_match';

  // Auth
  static const loginMethod = 'login_method';
  static const authProvider = 'auth_provider';
  static const signupMethod = 'signup_method';
  static const requestMethod = 'request_method';
  static const resetTokenValid = 'reset_token_valid';

  // Personalization
  static const personalizationStep = 'personalization_step';
  static const learningGoal = 'learning_goal';
  static const startingLevel = 'starting_level';
  static const dailyGoalMinutes = 'daily_goal_minutes';

  // Paywall / monetization
  static const paywallVariant = 'paywall_variant';
  static const offerSequence = 'offer_sequence';
  static const featureTrigger = 'feature_trigger';
  static const defaultPlan = 'default_plan';
  static const section = 'section';
  static const sectionState = 'section_state';
  static const planType = 'plan_type';
  static const productId = 'product_id';
  static const displayedPrice = 'displayed_price';
  static const currency = 'currency';
  static const price = 'price';
  static const transactionIdHash = 'transaction_id_hash';
  static const heartPackSize = 'heart_pack_size';
  static const heartBalanceBefore = 'heart_balance_before';
  static const heartBalanceAfter = 'heart_balance_after';
  static const restoredProductId = 'restored_product_id';
  static const restoredPlanType = 'restored_plan_type';
  static const closeOutcome = 'close_outcome';
  static const discountPercent = 'discount_percent';

  // Home
  static const entrySource = 'entry_source';
  static const homeState = 'home_state';
  static const todayLessonState = 'today_lesson_state';
  static const entryPoint = 'entry_point';
  static const currentXp = 'current_xp';
  static const navItem = 'nav_item';

  // XP modal
  static const nextUnlockType = 'next_unlock_type';
  static const xpToNextUnlock = 'xp_to_next_unlock';

  // AI Chat
  static const communicationMode = 'communication_mode';
  static const fromMode = 'from_mode';
  static const toMode = 'to_mode';
  static const lastMode = 'last_mode';
  static const messageCount = 'message_count';
  static const topicType = 'topic_type';
  static const messageSequence = 'message_sequence';
  static const inputMethod = 'input_method';
  static const heartAccessType = 'heart_access_type';
  static const heartCost = 'heart_cost';
  static const latencyMs = 'latency_ms';
  static const correctionState = 'correction_state';
  static const automaticAudioState = 'automatic_audio_state';
  static const heartCharged = 'heart_charged';
  static const responseAudioState = 'response_audio_state';
  static const fromAudioState = 'from_audio_state';
  static const toAudioState = 'to_audio_state';
  static const playbackSource = 'playback_source';
  static const microphonePermission = 'microphone_permission';
  static const captureDurationMs = 'capture_duration_ms';
  static const exitMethod = 'exit_method';

  // Out of hearts
  static const featureContext = 'feature_context';
  static const blockedAction = 'blocked_action';
  static const heartBalance = 'heart_balance';
  static const recoveryMethod = 'recovery_method';
  static const pronunciationAttemptNumber = 'pronunciation_attempt_number';

  // Role Play
  static const contentType = 'content_type';
  static const unlockRequirementType = 'unlock_requirement_type';
  static const xpRequired = 'xp_required';
  static const lockReason = 'lock_reason';
  static const moduleState = 'module_state';
  static const completedLessonCount = 'completed_lesson_count';
  static const moduleProgressPercent = 'module_progress_percent';
  static const contentStepCount = 'content_step_count';
  static const contentStepNumber = 'content_step_number';
  static const contentId = 'content_id';
  static const speakerRole = 'speaker_role';
  static const baseXpEarned = 'base_xp_earned';
  static const nextLessonState = 'next_lesson_state';
  static const lastStepNumber = 'last_step_number';
  static const saveAction = 'save_action';
  static const questionId = 'question_id';
  static const answerOptionId = 'answer_option_id';
  static const answerResult = 'answer_result';
  static const attemptNumber = 'attempt_number';
  static const incorrectAnswerCount = 'incorrect_answer_count';

  // CEFR Learn
  static const levelAccess = 'level_access';
  static const moduleCompletionBonusXp = 'module_completion_bonus_xp';

  // Lesson completed
  static const currentLessonId = 'current_lesson_id';
  static const nextLessonId = 'next_lesson_id';
  static const nextLessonNumber = 'next_lesson_number';

  // Profile
  static const field = 'field';
  static const authMethod = 'auth_method';
  static const currentThemeMode = 'current_theme_mode';
  static const toState = 'to_state';
  static const reminderHour = 'reminder_hour';
  static const reminderMinute = 'reminder_minute';
  static const appearanceMode = 'appearance_mode';

  // Pronunciation practice
  static const phraseId = 'phrase_id';
  static const phraseNumber = 'phrase_number';
  static const phraseCount = 'phrase_count';
  static const checkEntry = 'check_entry';
  static const speechDetected = 'speech_detected';
  static const overallScore = 'overall_score';
  static const wordFeedbackCount = 'word_feedback_count';
  static const practiceSessionId = 'practice_session_id';
}
