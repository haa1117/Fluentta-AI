/// Event name constants for GA4, per the Fluenta Analytics Event Catalogue.
/// Grouped by owning screen/modal. Automatic `screen_view` is fired via
/// [AnalyticsService.logScreenView] instead of a constant here.
class AnalyticsEvents {
  AnalyticsEvents._();

  // Splash
  static const splashViewed = 'splash_viewed';
  static const splashCompleted = 'splash_completed';
  static const splashLoadFailed = 'splash_load_failed';

  // Pre-login onboarding
  static const preLoginStepViewed = 'pre_login_step_viewed';
  static const preLoginNextClicked = 'pre_login_next_clicked';
  static const preLoginSkipped = 'pre_login_skipped';
  static const preLoginCompleted = 'pre_login_completed';

  // Language selection
  static const languageSelectionViewed = 'language_selection_viewed';
  static const languageSelected = 'language_selected';
  static const languageSelectionCompleted = 'language_selection_completed';

  // Login
  static const loginStarted = 'login_started';
  static const loginSubmitted = 'login_submitted';
  static const loginSuccess = 'login_success';
  static const loginFailed = 'login_failed';
  static const socialAuthStarted = 'social_auth_started';
  static const socialAuthFailed = 'social_auth_failed';
  static const socialAuthCancelled = 'social_auth_cancelled';
  static const forgotPasswordClicked = 'forgot_password_clicked';
  static const loginSignupClicked = 'login_signup_clicked';

  // Signup
  static const signupStarted = 'signup_started';
  static const signupSubmitted = 'signup_submitted';
  static const signupSuccess = 'signup_success';
  static const signupFailed = 'signup_failed';
  static const signupLoginClicked = 'signup_login_clicked';

  // Account created
  static const accountCreatedViewed = 'account_created_viewed';
  static const accountCreatedContinueClicked = 'account_created_continue_clicked';

  // Password recovery
  static const passwordResetRequested = 'password_reset_requested';
  static const passwordResetRequestSucceeded = 'password_reset_request_succeeded';
  static const passwordResetRequestFailed = 'password_reset_request_failed';
  static const resetSigninClicked = 'reset_signin_clicked';
  static const passwordUpdateSubmitted = 'password_update_submitted';
  static const passwordUpdateSucceeded = 'password_update_succeeded';
  static const passwordUpdateFailed = 'password_update_failed';
  static const passwordUpdatedReturnClicked = 'password_updated_return_clicked';

  // Personalization
  static const personalizationStepViewed = 'personalization_step_viewed';
  static const learningGoalSelected = 'learning_goal_selected';
  static const personalizationStepCompleted = 'personalization_step_completed';
  static const startingLevelSelected = 'starting_level_selected';
  static const dailyGoalSelected = 'daily_goal_selected';
  static const personalizationCompleted = 'personalization_completed';

  // Paywall / monetization
  static const paywallViewed = 'paywall_viewed';
  static const paywallSectionChanged = 'paywall_section_changed';
  static const paywallPlanSelected = 'paywall_plan_selected';
  static const paywallCtaClicked = 'paywall_cta_clicked';
  static const purchaseStarted = 'purchase_started';
  static const purchaseSuccess = 'purchase_success';
  static const purchaseFailed = 'purchase_failed';
  static const purchaseCancelled = 'purchase_cancelled';
  static const heartPackSelected = 'heart_pack_selected';
  static const heartPurchaseStarted = 'heart_purchase_started';
  static const heartPurchaseSuccess = 'heart_purchase_success';
  static const heartPurchaseFailed = 'heart_purchase_failed';
  static const heartPurchaseCancelled = 'heart_purchase_cancelled';
  static const restorePurchaseClicked = 'restore_purchase_clicked';
  static const restorePurchaseSucceeded = 'restore_purchase_succeeded';
  static const restorePurchaseFailed = 'restore_purchase_failed';
  static const paywallClosed = 'paywall_closed';

  // heart_purchase_success modal
  static const heartPurchaseSuccessViewed = 'heart_purchase_success_viewed';
  static const heartPurchaseContinueClicked = 'heart_purchase_continue_clicked';

  // Home
  static const homeViewed = 'home_viewed';
  static const aiChatClicked = 'ai_chat_clicked';
  static const todayLessonClicked = 'today_lesson_clicked';
  static const xpIconClicked = 'xp_icon_clicked';
  static const bottomNavClicked = 'bottom_nav_clicked';

  // xp_view modal
  static const xpViewed = 'xp_viewed';

  // AI Chat
  static const aiChatViewed = 'ai_chat_viewed';
  static const aiChatModeChanged = 'ai_chat_mode_changed';
  static const aiChatTopicSelected = 'ai_chat_topic_selected';
  static const aiChatMessageSubmitted = 'ai_chat_message_submitted';
  static const aiChatResponseReceived = 'ai_chat_response_received';
  static const aiChatResponseFailed = 'ai_chat_response_failed';
  static const aiResponseAudioToggled = 'ai_response_audio_toggled';
  static const aiResponsePlayClicked = 'ai_response_play_clicked';
  static const aiResponseAudioStarted = 'ai_response_audio_started';
  static const aiResponseAudioFailed = 'ai_response_audio_failed';
  static const voiceCaptureStarted = 'voice_capture_started';
  static const voiceCaptureCompleted = 'voice_capture_completed';
  static const voiceCaptureCancelled = 'voice_capture_cancelled';
  static const voiceCaptureFailed = 'voice_capture_failed';
  static const aiChatExited = 'ai_chat_exited';

  // out_of_hearts modal
  static const outOfHeartsViewed = 'out_of_hearts_viewed';
  static const goUnlimitedClicked = 'go_unlimited_clicked';
  static const outOfHeartsDismissed = 'out_of_hearts_dismissed';
  static const heartGatedActionResumed = 'heart_gated_action_resumed';

  // Role Play
  static const rolePlayViewed = 'role_play_viewed';
  static const pronunciationPracticeClicked = 'pronunciation_practice_clicked';
  static const rolePlayScenarioClicked = 'role_play_scenario_clicked';
  static const lockedContentClicked = 'locked_content_clicked';
  static const rolePlayScenarioViewed = 'role_play_scenario_viewed';
  static const rolePlayModuleClicked = 'role_play_module_clicked';
  static const rolePlayModuleViewed = 'role_play_module_viewed';
  static const rolePlayLessonClicked = 'role_play_lesson_clicked';
  static const rolePlayLessonStarted = 'role_play_lesson_started';
  static const lessonStepViewed = 'lesson_step_viewed';
  static const dialogueAudioPlayed = 'dialogue_audio_played';
  static const rolePlayLessonCompleted = 'role_play_lesson_completed';
  static const rolePlayLessonExited = 'role_play_lesson_exited';
  static const vocabularyAudioPlayed = 'vocabulary_audio_played';
  static const vocabularySaveUpdated = 'vocabulary_save_updated';
  static const comprehensionAnswerSubmitted = 'comprehension_answer_submitted';
  static const comprehensionGuidanceViewed = 'comprehension_guidance_viewed';

  // Role Play premium lock (not in PRD registry — added per product decision;
  // see conversation: advanced scenarios are Premium-gated, not XP-gated).
  static const roleplayScenarioLockedClicked = 'roleplay_scenario_locked_clicked';
  static const premiumUpsellViewed = 'premium_upsell_viewed';
  static const premiumUpsellGoUnlimitedClicked = 'premium_upsell_go_unlimited_clicked';
  static const premiumUpsellDismissed = 'premium_upsell_dismissed';

  // CEFR Learn
  static const learnViewed = 'learn_viewed';
  static const cefrLevelClicked = 'cefr_level_clicked';
  static const cefrModuleClicked = 'cefr_module_clicked';
  static const savedWordsClicked = 'saved_words_clicked';
  static const cefrModuleViewed = 'cefr_module_viewed';
  static const cefrLessonClicked = 'cefr_lesson_clicked';
  static const cefrLessonStarted = 'cefr_lesson_started';
  static const cefrLessonCompleted = 'cefr_lesson_completed';
  static const cefrLessonExited = 'cefr_lesson_exited';
  static const grammarExampleAudioPlayed = 'grammar_example_audio_played';
  static const readingAudioPlayed = 'reading_audio_played';

  // Shared lesson_completed screen
  static const lessonCompletionViewed = 'lesson_completion_viewed';
  static const startNextLessonClicked = 'start_next_lesson_clicked';
  static const lessonCompletionClosed = 'lesson_completion_closed';

  // Profile (added per product decision — not in the supplied PRD, whose
  // scope explicitly excluded Profile; drafted from the shipped screens).
  static const profileViewed = 'profile_viewed';
  static const accountSecurityClicked = 'account_security_clicked';
  static const changeDailyGoalClicked = 'change_daily_goal_clicked';
  static const profileLanguageClicked = 'profile_language_clicked';
  static const notificationsSettingsClicked = 'notifications_settings_clicked';
  static const appAppearanceClicked = 'app_appearance_clicked';
  static const upgradeToPremiumClicked = 'upgrade_to_premium_clicked';
  static const signOutClicked = 'sign_out_clicked';
  static const deleteAccountClicked = 'delete_account_clicked';
  static const accountFieldClicked = 'account_field_clicked';
  static const passwordChangeUnavailableShown = 'password_change_unavailable_shown';
  static const nameUpdateSubmitted = 'name_update_submitted';
  static const nameUpdateSucceeded = 'name_update_succeeded';
  static const nameUpdateFailed = 'name_update_failed';
  // Namespaced (profile_*) to avoid colliding with the recovery-flow
  // password_update_* events above, which belong to a different screen.
  static const profilePasswordUpdateSubmitted = 'profile_password_update_submitted';
  static const profilePasswordUpdateSucceeded = 'profile_password_update_succeeded';
  static const profilePasswordUpdateFailed = 'profile_password_update_failed';
  static const notificationsToggled = 'notifications_toggled';
  static const dailyReminderToggled = 'daily_reminder_toggled';
  static const reminderTimeClicked = 'reminder_time_clicked';
  static const reminderTimeSaved = 'reminder_time_saved';
  static const reminderTimeCancelled = 'reminder_time_cancelled';
  static const deleteAccountConfirmed = 'delete_account_confirmed';
  static const deleteAccountSucceeded = 'delete_account_succeeded';
  static const deleteAccountFailed = 'delete_account_failed';
  static const deleteAccountCancelled = 'delete_account_cancelled';
  static const appearanceModeSelected = 'appearance_mode_selected';
  static const dailyGoalUpdated = 'daily_goal_updated';

  // Pronunciation practice (not in the supplied catalogue beyond the Role
  // Play entry click; destinations were pending. Drafted from the shipped
  // nested flow: home → recording → checking → result → complete.)
  static const pronunciationPracticeViewed = 'pronunciation_practice_viewed';
  static const pronunciationPhraseAudioPlayed = 'pronunciation_phrase_audio_played';
  static const pronunciationCheckStarted = 'pronunciation_check_started';
  static const pronunciationRecordingStarted = 'pronunciation_recording_started';
  static const pronunciationRecordingCompleted = 'pronunciation_recording_completed';
  static const pronunciationRecordingCancelled = 'pronunciation_recording_cancelled';
  static const pronunciationRecordingFailed = 'pronunciation_recording_failed';
  static const pronunciationCheckingViewed = 'pronunciation_checking_viewed';
  static const pronunciationCheckSucceeded = 'pronunciation_check_succeeded';
  static const pronunciationCheckFailed = 'pronunciation_check_failed';
  static const pronunciationResultViewed = 'pronunciation_result_viewed';
  static const pronunciationTryAgainClicked = 'pronunciation_try_again_clicked';
  static const pronunciationNextPhraseClicked = 'pronunciation_next_phrase_clicked';
  static const pronunciationFinishClicked = 'pronunciation_finish_clicked';
  static const pronunciationSessionCompleted = 'pronunciation_session_completed';
  static const pronunciationPracticeMoreClicked = 'pronunciation_practice_more_clicked';
  static const pronunciationBackToSpeakClicked = 'pronunciation_back_to_speak_clicked';

  // More apps
  static const moreAppsClicked = 'more_apps_click';

  // App tutorial
  static const tutorialStarted = 'tutorial_started';
  static const tutorialStepViewed = 'tutorial_step_viewed';
  static const tutorialSkipped = 'tutorial_skipped';
  static const tutorialCompleted = 'tutorial_completed';
}
