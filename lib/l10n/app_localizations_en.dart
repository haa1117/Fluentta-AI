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
}
