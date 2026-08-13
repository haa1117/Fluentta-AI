// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fluenta';

  @override
  String get aiEnglishTutor => 'AI English Tutor';

  @override
  String get speakWithAiTutor => 'Speak English with your AI tutor.';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get continueBtn => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get open => 'Open';

  @override
  String get start => 'Start';

  @override
  String get previous => 'Previous';

  @override
  String get finishLesson => 'Finish Lesson';

  @override
  String get startNextLesson => 'Start Next Lesson';

  @override
  String lessonProgress(int number) {
    return 'LESSON $number PROGRESS';
  }

  @override
  String lessonTitle(int number) {
    return 'Lesson $number';
  }

  @override
  String get lessonPhase => 'LESSON PHASE';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In progress';

  @override
  String get locked => 'Locked';

  @override
  String get notStarted => 'Not started';

  @override
  String wordsProgress(int done, int total, String status) {
    return '$done/$total words • $status';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done / $total lessons completed';
  }

  @override
  String get completedLessonsReview =>
      'Completed lessons stay open for review.';

  @override
  String get lessonContentSoon => 'Lesson content coming soon';

  @override
  String openingCategory(String title) {
    return 'Opening $title...';
  }

  @override
  String get onboardingTitle1 => 'Meet Your AI English Tutor';

  @override
  String get onboardingDesc1 =>
      'Practice English by chatting or speaking \n with your personal AI tutor';

  @override
  String get onboardingTitle2 => 'Get Instant Corrections';

  @override
  String get onboardingDesc2 =>
      'Fix Grammar, word choice, and sentences while you practice';

  @override
  String get onboardingTitle3 => 'Improve Every Day';

  @override
  String get onboardingDesc3 =>
      'Build your English with daily practice and simple progress tracking';

  @override
  String get chooseYourLanguage => 'Choose Your Language';

  @override
  String get personalizeExperience => 'We Personalize your learning Experience';

  @override
  String get suggestedForYou => 'Suggested For You';

  @override
  String get otherLanguages => 'Other Languages';

  @override
  String get recommendedRegion => 'Recommended based on your region';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageFrench => 'French';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String get signInSubtitle => 'Continue your English learning journey.';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountSubtitle =>
      'Save your learning progress across devices';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get minEightChars => 'Min. 8 characters';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get rememberPassword => 'Remember your password? ';

  @override
  String get forgotPasswordTitle => 'Forgot your password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter the email linked to your account.\n We\'ll send you a verification code.';

  @override
  String get sendVerificationCode => 'Send Verification Code';

  @override
  String get verificationEmailSent => 'Verification email sent successfully.';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String otpSentTo(String email) {
    return 'We sent a 4-digit code to $email';
  }

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get verificationCodeResent => 'Verification code resent.';

  @override
  String get didntReceiveCode => 'Didn\'t receive the code? ';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get passwordUpdated => 'Password Updated!';

  @override
  String get passwordUpdatedDesc =>
      'Your password has been updated successfully.\nYou can now sign in with your new password';

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get accountCreatedTitle => 'Account Created!';

  @override
  String get accountCreatedDesc =>
      'Your account has been created successfully.\nLet\'s set up your learning preferences.';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get setupGoalTitle => 'What\'s Your English Goal?';

  @override
  String get setupGoalSubtitle =>
      'Your tutor will create practice based on your goal.';

  @override
  String get setupLevelTitle => 'Start Your Starting Point';

  @override
  String get setupLevelSubtitle =>
      'We\'ll personalize your lessons based on your level.';

  @override
  String get setupDailyTitle => 'Set Your Daily Goal';

  @override
  String get setupDailySubtitle =>
      'Small daily practice builds real English fluency.';

  @override
  String get goalTravel => 'Travel';

  @override
  String get goalTravelSub => 'Easy Local Conversation';

  @override
  String get goalWork => 'Work';

  @override
  String get goalWorkSub => 'Master Workplace English';

  @override
  String get goalExam => 'Exam';

  @override
  String get goalExamSub => 'IELTS, TOEFL & Interviews';

  @override
  String get goalEveryday => 'Everyday English';

  @override
  String get goalEverydaySub => 'Practice natural conversation';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelBeginnerSub => 'A1 · New to English Basics';

  @override
  String get levelElementary => 'Elementary';

  @override
  String get levelElementarySub => 'A2 · Can use simple words';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelIntermediateSub => 'B1 · Can hold simple conversation';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelAdvancedSub => 'B2+ · Comfortable in most situations';

  @override
  String get daily5 => '5 minutes';

  @override
  String get daily5Sub => 'Perfect for busy days';

  @override
  String get daily10 => '10 Minutes';

  @override
  String get daily10Sub => 'Best for consistent progress';

  @override
  String get daily15 => '15 minutes';

  @override
  String get daily15Sub => 'Learn more with focused practice';

  @override
  String get daily20 => '20 minutes';

  @override
  String get daily20Sub => 'For faster improvement';

  @override
  String get navHome => 'Home';

  @override
  String get navLearn => 'Learn';

  @override
  String get navSpeak => 'Speak';

  @override
  String get navProfile => 'Profile';

  @override
  String get readyToPractice => 'Ready to practice?';

  @override
  String get journeyContinues => 'Your English journey continues here.';

  @override
  String get learnAndGrow => 'Learn & grow';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get vocabularySub => '5 words to review';

  @override
  String get grammar => 'Grammar';

  @override
  String get grammarSub => 'Quick practice';

  @override
  String get reading => 'Reading';

  @override
  String get readingSub => 'Short passage';

  @override
  String get savedWords => 'Saved Words';

  @override
  String get savedWordsSub => '12 words to review';

  @override
  String get yourLevel => 'Your level';

  @override
  String get beginnerLevel => 'Beginner';

  @override
  String get speakTitle => 'Speak';

  @override
  String get speakSubtitle => 'Practice speaking with your AI tutor';

  @override
  String get speakComingSoon => 'Speaking practice coming soon';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileSettingsSub => 'App preferences';

  @override
  String get signOut => 'Sign Out';

  @override
  String get user => 'User';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String vocabularyPathTitle(String level) {
    return '$level Vocabulary Path';
  }

  @override
  String get vocabularyPathSub =>
      'Learn 50 useful beginner words\nstep by step.';

  @override
  String grammarPathTitle(String level) {
    return '$level Grammar Path';
  }

  @override
  String get grammarPathSub => 'Learn simple grammar rules\nstep by step.';

  @override
  String readingPathTitle(String level) {
    return '$level Reading Path';
  }

  @override
  String get readingPathSub => 'Read short English passages\nstep by step.';

  @override
  String get previousWord => 'Previous Word';

  @override
  String get nextWord => 'Next Word';

  @override
  String get listen => 'Listen';

  @override
  String get save => 'Save';

  @override
  String get meaning => 'MEANING';

  @override
  String get example => 'EXAMPLE';

  @override
  String wordIndex(int index) {
    return 'Word .$index';
  }

  @override
  String wordsLearned(int count) {
    return '$count Words Learned';
  }

  @override
  String lessonCompletedSuccess(int number) {
    return 'You have completed Lesson $number \n successfully';
  }

  @override
  String grammarLessonCompleted(int number) {
    return 'You have completed Grammar Lesson $number Successfully';
  }

  @override
  String readingLessonCompleted(int number) {
    return 'You have completed Reading Lesson $number Successfully';
  }

  @override
  String get learnedUseOf => 'You have learned the use of';

  @override
  String get youHaveLearned => 'You have learned';

  @override
  String get quickTip => 'Quick Tip';

  @override
  String get fluentaTip => 'Fluenta Tip';

  @override
  String playingWord(String word) {
    return 'Playing \"$word\"...';
  }

  @override
  String get wordSaved => 'Word saved!';

  @override
  String get wordRemoved => 'Removed from saved words';

  @override
  String get aiTutor => 'AI Tutor';

  @override
  String get howToPracticeToday => 'How do you want to\npractice today?';

  @override
  String get openChatPractice => 'Open Chat Practice';

  @override
  String get openChatPracticeSub => 'Free conversation with instant feedback';

  @override
  String get startAiChat => 'Start AI Chat';

  @override
  String get roleplayScenarios => 'Roleplay Scenarios';

  @override
  String get openingChatPractice => 'Opening chat practice...';

  @override
  String selectedScenario(String title) {
    return 'Selected: $title';
  }

  @override
  String get lesson1DailyWords => 'Daily Words';

  @override
  String get lesson2WorkplaceWords => 'Workplace Words';

  @override
  String get lesson3TravelWords => 'Travel Words';

  @override
  String get lesson1DailyRoutine => 'Daily Routine';

  @override
  String get lesson2OfficeDialogue => 'Office Dialogue';

  @override
  String get lesson3TravelStory => 'Travel Story';

  @override
  String get lessonRestaurantTalk => 'Restaurant Talk';

  @override
  String get lessonFamilyStory => 'Family Story';

  @override
  String get lessonShoppingStory => 'Shopping Story';

  @override
  String get lessonDoctorVisit => 'Doctor Visit';

  @override
  String get lessonWorkEmail => 'Work Email';

  @override
  String get lessonWeekendPlan => 'Weekend Plan';

  @override
  String get lessonDirections => 'Directions';

  @override
  String get lesson1IAmYouAre => 'I am / you are';

  @override
  String get lesson2PresentSimple => 'Present Simple';

  @override
  String get lessonArticles => 'A / an / The';

  @override
  String get lessonThisThat => 'This / That';

  @override
  String get lessonHeSheThey => 'He / She / They';

  @override
  String get lessonThereIsAre => 'There is / There are';

  @override
  String get lessonCanCannot => 'Can / Cannot';

  @override
  String get lessonHaveHas => 'Have / Has';

  @override
  String get lessonWasWere => 'Was / Were';

  @override
  String get lessonWillGoingTo => 'Will / Going to';

  @override
  String get presentSimpleLearned => 'Present Simple Learned';

  @override
  String get officeDialogueLearned => 'Office Dialogue Learned';

  @override
  String get generalOfficeConversation => 'General office conversation';

  @override
  String get presentSimpleSummary => 'He, she, it, I, you, we';

  @override
  String get grammarStepIYouWe => 'I You We';

  @override
  String get grammarStepIYouWeDesc => 'Use the base verb with I, you, and we.';

  @override
  String get grammarStepIYouWeFormula => 'I / You / We + verb';

  @override
  String get grammarStepHeSheIt => 'He, She, It';

  @override
  String get grammarStepHeSheItDesc =>
      'With he, she, and it, add \'s\' to the verb.';

  @override
  String get grammarStepHeSheItFormula => 'He / She / It + verb + s';

  @override
  String get grammarTipNoS => 'Do not use \'s\' with i, you, we or they.';

  @override
  String get grammarTipNeedS => 'He, she, and it usually need \'s\'.';

  @override
  String readingDialoguePart(int part) {
    return 'Dialogue Part $part';
  }

  @override
  String get readingManager => 'Manager';

  @override
  String get readingYou => 'You';

  @override
  String get readingManagerLine => '\"Can you join the meeting at 10?\"';

  @override
  String get readingYouLine => '\"Yes, I can join the meeting.\"';

  @override
  String get readingFluentaTipText =>
      'Try speaking the \'You\' response out loud to practice your office-ready pronunciation!';

  @override
  String get levelA1 => 'A1';

  @override
  String get levelA2 => 'A2';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB2 => 'B2+';

  @override
  String get profileTitle => 'Profile';

  @override
  String get hi => 'Hi,';

  @override
  String get a1Beginner => 'A1 Beginner';

  @override
  String get learningWithFluenta => 'Learning English with Fluentta';

  @override
  String dayStreak(int days) {
    return 'Day $days';
  }

  @override
  String get progressLabel => 'PROGRESS';

  @override
  String get freePlan => 'Free Plan';

  @override
  String heartsDaily(int count) {
    return '$count hearts daily';
  }

  @override
  String get upgradePremiumDesc =>
      'Upgrade for unlimited AI practice, pronunciation checks, full roleplays, and no ads.';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get yourStats => 'YOUR STATS';

  @override
  String get xpEarned => 'XP earned';

  @override
  String get wordsStat => 'Words';

  @override
  String get lessonsStat => 'Lessons';

  @override
  String get correctionsStat => 'Corrections';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get changeGoal => 'Change Goal';

  @override
  String minPerDay(int minutes) {
    return '$minutes min per day';
  }

  @override
  String minToday(int done, int total) {
    return '$done / $total min today';
  }

  @override
  String get settingsSection => 'SETTINGS';

  @override
  String get notificationsReminders => 'Notifications & reminders';

  @override
  String dailyReminderAt(String time) {
    return 'Daily reminder at $time';
  }

  @override
  String get appAppearance => 'App Appearance';

  @override
  String get lightMode => 'Light mode';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get supportLegal => 'SUPPORT & LEGAL';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get rateApp => 'Rate App';

  @override
  String get accountActions => 'ACCOUNT ACTIONS';

  @override
  String get signOutTitle => 'Sign out';

  @override
  String get signOutSub => 'Sign out from your account';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountSub => 'Delete account permanently';

  @override
  String get allowNotifications => 'Allow Notifications';

  @override
  String get allowNotificationsSub => 'Receive reminders and learning updates';

  @override
  String get practiceReminders => 'PRACTICE REMINDERS';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get reminderTimeTitle => 'Reminder Time';

  @override
  String get chooseReminderTime =>
      'Choose when you\'d like to practice every day.';

  @override
  String get saveReminder => 'Save Reminder';

  @override
  String get cancelBtn => 'Cancel';

  @override
  String get signOutQuestion => 'Sign out?';

  @override
  String get signOutDialogMessage =>
      'Your saved progress will stay safe. You will need to sign in again to sync and restore premium access';

  @override
  String get deleteAccountQuestion => 'Delete Account?';

  @override
  String get deleteAccountDialogMessage =>
      'This will permanently delete your account, progress, saved words and learning history.';

  @override
  String get deleteAccountConfirmation => 'Delete Account Confirmation';

  @override
  String get warning => 'Warning';

  @override
  String get deleteWarningMessage =>
      'This action will permanently remove all your progress, stats, and personal data. This cannot be undone.';

  @override
  String get understandPermanent => 'I understand this action is permanent.';

  @override
  String get deleteAccountBtn => 'Delete Account';

  @override
  String get deleteMarketingNote =>
      'Deleting your account will also unsubscribe you from all marketing communications.';

  @override
  String get accountDeleted => 'Account Deleted';

  @override
  String get accountDeletedMessage =>
      'Your account and learning data have been deleted.';

  @override
  String get sorryToSeeYouGo => 'We are sorry to see you go';

  @override
  String get done => 'Done';

  @override
  String get createAccountAnytime => 'You can create your account anytime.';

  @override
  String englishExplanationsIn(String language) {
    return 'English explanations in $language';
  }

  @override
  String get lessonsQuickLink => 'Lessons';

  @override
  String get correctionsQuickLink => 'Corrections';

  @override
  String get openingSoon => 'Coming soon';

  @override
  String get upgradeComingSoon => 'Premium upgrade coming soon';

  @override
  String get restoringPurchases => 'Restoring purchases...';

  @override
  String get speakWithAiTutorTitle => 'Speak With AI Tutor';

  @override
  String get aiSpeakingTutor => 'AI Speaking Tutor';

  @override
  String get aiSpeakingTutorDesc =>
      'Talk by voice or text and get instant corrections';

  @override
  String get tagVoice => 'Voice';

  @override
  String get tagText => 'Text';

  @override
  String get tagCorrections => 'Corrections';

  @override
  String get pronunciationPractice => 'Pronunciation Practice';

  @override
  String get pronunciationPracticeSub => 'Record voice and get feedback';

  @override
  String get advertisement => 'ADVERTISEMENT';

  @override
  String get bannerAdPlaceholder => 'Banner Ad Placeholder';

  @override
  String get openAiChatPractice => 'Open AI Chat Practice';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get pronunciationPracticeDesc =>
      'Read a phrase, record your voice, and get feedback.';

  @override
  String phraseOf(int current, int total) {
    return 'Phrase $current of $total';
  }

  @override
  String get speakClearly => 'Speak clearly and naturally.';

  @override
  String get startRecording => 'Start Recording';

  @override
  String get heartPerPronunciation => '1 heart per Pronunciation';

  @override
  String get recording => 'RECORDING...';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get checkingPronunciation => 'Checking your pronunciation...';

  @override
  String get checkingPronunciationSub =>
      'We\'re listening for clarity, rhythm, and word accuracy to provide your personalized feedback.';

  @override
  String get onlyTakesMoment => 'This only takes a moment.';

  @override
  String get greatEffort => 'Great effort!';

  @override
  String pronunciationScoreMessage(int score) {
    return 'Your pronunciation is clearer than $score% of learners at your level. Keep it up!';
  }

  @override
  String get wordFeedback => 'WORD FEEDBACK';

  @override
  String confidencePercent(int percent) {
    return '$percent% Confidence';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get nextPhrase => 'Next Phrase';

  @override
  String get finish => 'Finish';

  @override
  String get practiceComplete => 'Practice Complete';

  @override
  String practicedPhrases(int count) {
    return 'You Practiced $count pronunciation Phrases';
  }

  @override
  String get averageScore => 'AVERAGE SCORE';

  @override
  String get phrasesLabel => 'Phrases';

  @override
  String get bestWord => 'Best word';

  @override
  String get practiceMore => 'Practice More';

  @override
  String get backToSpeak => 'Back to Speak';

  @override
  String get openChatPracticeTitle => 'Open Chat Practice';

  @override
  String get textMode => 'Text Mode';

  @override
  String get chatGreeting => 'Hi! What would you like to practice today?';

  @override
  String get outOfHearts => 'You\'re out of Hearts';

  @override
  String get outOfHeartsSub =>
      'Fix Grammar, word choice, and sentences while you practice';

  @override
  String get getMoreHearts => 'GET MORE HEARTS';

  @override
  String get goUnlimited => 'Go Unlimited';

  @override
  String get goUnlimitedSub =>
      'Unlimited AI practice\nNo ads • Unlimited hearts';

  @override
  String get watchAd => 'Watch Ad';

  @override
  String get watchAdSub => 'Get +2 Hearts instantly';

  @override
  String get playingPhrase => 'Playing phrase...';

  @override
  String get scenarioJobInterviews => 'Job Interviews';

  @override
  String get scenarioOrderFood => 'Order Food';

  @override
  String get scenarioAtAirport => 'At Airport';

  @override
  String get scenarioDoctorVisit => 'Doctor\'s Visit';

  @override
  String get scenarioSmallTalk => 'Small Talk';

  @override
  String get scenarioBusinessMeeting => 'Business Meeting';

  @override
  String get learnAndPractice => 'Learn & Practice';

  @override
  String get quickCheck => 'Quick Check';

  @override
  String get quickCheckSub => 'Answer comprehension questions';

  @override
  String roleplayPracticeTitle(String title) {
    return '$title Practice';
  }

  @override
  String get scenarioJobInterviewDetail => 'Job Interview';

  @override
  String get scenarioJobInterviewVocabSub => 'Learn key interview words';

  @override
  String get scenarioOrderFoodDetail => 'Order Food';

  @override
  String get scenarioOrderFoodVocabSub => 'Learn key restaurant words';

  @override
  String get scenarioAtAirportDetail => 'At the Airport';

  @override
  String get scenarioAtAirportVocabSub => 'Learn key travel words';

  @override
  String get scenarioDoctorVisitDetail => 'Doctor Visit';

  @override
  String get scenarioDoctorVisitVocabSub => 'Learn key medical words';

  @override
  String get scenarioSmallTalkDetail => 'Small Talk';

  @override
  String get scenarioSmallTalkVocabSub => 'Learn key conversation words';

  @override
  String get scenarioBusinessMeetingDetail => 'Business Meeting';

  @override
  String get scenarioBusinessMeetingVocabSub => 'Learn key meeting words';
}
