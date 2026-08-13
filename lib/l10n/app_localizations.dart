import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ur'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Fluenta'**
  String get appName;

  /// No description provided for @aiEnglishTutor.
  ///
  /// In en, this message translates to:
  /// **'AI English Tutor'**
  String get aiEnglishTutor;

  /// No description provided for @speakWithAiTutor.
  ///
  /// In en, this message translates to:
  /// **'Speak English with your AI tutor.'**
  String get speakWithAiTutor;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @finishLesson.
  ///
  /// In en, this message translates to:
  /// **'Finish Lesson'**
  String get finishLesson;

  /// No description provided for @startNextLesson.
  ///
  /// In en, this message translates to:
  /// **'Start Next Lesson'**
  String get startNextLesson;

  /// No description provided for @lessonProgress.
  ///
  /// In en, this message translates to:
  /// **'LESSON {number} PROGRESS'**
  String lessonProgress(int number);

  /// No description provided for @lessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson {number}'**
  String lessonTitle(int number);

  /// No description provided for @lessonPhase.
  ///
  /// In en, this message translates to:
  /// **'LESSON PHASE'**
  String get lessonPhase;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get notStarted;

  /// No description provided for @wordsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} words • {status}'**
  String wordsProgress(int done, int total, String status);

  /// No description provided for @lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} lessons completed'**
  String lessonsCompleted(int done, int total);

  /// No description provided for @completedLessonsReview.
  ///
  /// In en, this message translates to:
  /// **'Completed lessons stay open for review.'**
  String get completedLessonsReview;

  /// No description provided for @lessonContentSoon.
  ///
  /// In en, this message translates to:
  /// **'Lesson content coming soon'**
  String get lessonContentSoon;

  /// No description provided for @openingCategory.
  ///
  /// In en, this message translates to:
  /// **'Opening {title}...'**
  String openingCategory(String title);

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Meet Your AI English Tutor'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Practice English by chatting or speaking \n with your personal AI tutor'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Get Instant Corrections'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Fix Grammar, word choice, and sentences while you practice'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Improve Every Day'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Build your English with daily practice and simple progress tracking'**
  String get onboardingDesc3;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseYourLanguage;

  /// No description provided for @personalizeExperience.
  ///
  /// In en, this message translates to:
  /// **'We Personalize your learning Experience'**
  String get personalizeExperience;

  /// No description provided for @suggestedForYou.
  ///
  /// In en, this message translates to:
  /// **'Suggested For You'**
  String get suggestedForYou;

  /// No description provided for @otherLanguages.
  ///
  /// In en, this message translates to:
  /// **'Other Languages'**
  String get otherLanguages;

  /// No description provided for @recommendedRegion.
  ///
  /// In en, this message translates to:
  /// **'Recommended based on your region'**
  String get recommendedRegion;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @signInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Email'**
  String get signInWithEmail;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your English learning journey.'**
  String get signInSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save your learning progress across devices'**
  String get createAccountSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @minEightChars.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters'**
  String get minEightChars;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email linked to your account.\n We\'ll send you a verification code.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendVerificationCode;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent successfully.'**
  String get verificationEmailSent;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 4-digit code to {email}'**
  String otpSentTo(String email);

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @verificationCodeResent.
  ///
  /// In en, this message translates to:
  /// **'Verification code resent.'**
  String get verificationCodeResent;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password Updated!'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully.\nYou can now sign in with your new password'**
  String get passwordUpdatedDesc;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @accountCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Created!'**
  String get accountCreatedTitle;

  /// No description provided for @accountCreatedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully.\nLet\'s set up your learning preferences.'**
  String get accountCreatedDesc;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @setupGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s Your English Goal?'**
  String get setupGoalTitle;

  /// No description provided for @setupGoalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your tutor will create practice based on your goal.'**
  String get setupGoalSubtitle;

  /// No description provided for @setupLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Your Starting Point'**
  String get setupLevelTitle;

  /// No description provided for @setupLevelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll personalize your lessons based on your level.'**
  String get setupLevelSubtitle;

  /// No description provided for @setupDailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Your Daily Goal'**
  String get setupDailyTitle;

  /// No description provided for @setupDailySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small daily practice builds real English fluency.'**
  String get setupDailySubtitle;

  /// No description provided for @goalTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get goalTravel;

  /// No description provided for @goalTravelSub.
  ///
  /// In en, this message translates to:
  /// **'Easy Local Conversation'**
  String get goalTravelSub;

  /// No description provided for @goalWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get goalWork;

  /// No description provided for @goalWorkSub.
  ///
  /// In en, this message translates to:
  /// **'Master Workplace English'**
  String get goalWorkSub;

  /// No description provided for @goalExam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get goalExam;

  /// No description provided for @goalExamSub.
  ///
  /// In en, this message translates to:
  /// **'IELTS, TOEFL & Interviews'**
  String get goalExamSub;

  /// No description provided for @goalEveryday.
  ///
  /// In en, this message translates to:
  /// **'Everyday English'**
  String get goalEveryday;

  /// No description provided for @goalEverydaySub.
  ///
  /// In en, this message translates to:
  /// **'Practice natural conversation'**
  String get goalEverydaySub;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelBeginnerSub.
  ///
  /// In en, this message translates to:
  /// **'A1 · New to English Basics'**
  String get levelBeginnerSub;

  /// No description provided for @levelElementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get levelElementary;

  /// No description provided for @levelElementarySub.
  ///
  /// In en, this message translates to:
  /// **'A2 · Can use simple words'**
  String get levelElementarySub;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelIntermediateSub.
  ///
  /// In en, this message translates to:
  /// **'B1 · Can hold simple conversation'**
  String get levelIntermediateSub;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelAdvancedSub.
  ///
  /// In en, this message translates to:
  /// **'B2+ · Comfortable in most situations'**
  String get levelAdvancedSub;

  /// No description provided for @daily5.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get daily5;

  /// No description provided for @daily5Sub.
  ///
  /// In en, this message translates to:
  /// **'Perfect for busy days'**
  String get daily5Sub;

  /// No description provided for @daily10.
  ///
  /// In en, this message translates to:
  /// **'10 Minutes'**
  String get daily10;

  /// No description provided for @daily10Sub.
  ///
  /// In en, this message translates to:
  /// **'Best for consistent progress'**
  String get daily10Sub;

  /// No description provided for @daily15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get daily15;

  /// No description provided for @daily15Sub.
  ///
  /// In en, this message translates to:
  /// **'Learn more with focused practice'**
  String get daily15Sub;

  /// No description provided for @daily20.
  ///
  /// In en, this message translates to:
  /// **'20 minutes'**
  String get daily20;

  /// No description provided for @daily20Sub.
  ///
  /// In en, this message translates to:
  /// **'For faster improvement'**
  String get daily20Sub;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navSpeak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get navSpeak;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @readyToPractice.
  ///
  /// In en, this message translates to:
  /// **'Ready to practice?'**
  String get readyToPractice;

  /// No description provided for @journeyContinues.
  ///
  /// In en, this message translates to:
  /// **'Your English journey continues here.'**
  String get journeyContinues;

  /// No description provided for @learnAndGrow.
  ///
  /// In en, this message translates to:
  /// **'Learn & grow'**
  String get learnAndGrow;

  /// No description provided for @vocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabulary;

  /// No description provided for @vocabularySub.
  ///
  /// In en, this message translates to:
  /// **'5 words to review'**
  String get vocabularySub;

  /// No description provided for @grammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get grammar;

  /// No description provided for @grammarSub.
  ///
  /// In en, this message translates to:
  /// **'Quick practice'**
  String get grammarSub;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @readingSub.
  ///
  /// In en, this message translates to:
  /// **'Short passage'**
  String get readingSub;

  /// No description provided for @savedWords.
  ///
  /// In en, this message translates to:
  /// **'Saved Words'**
  String get savedWords;

  /// No description provided for @savedWordsSub.
  ///
  /// In en, this message translates to:
  /// **'12 words to review'**
  String get savedWordsSub;

  /// No description provided for @yourLevel.
  ///
  /// In en, this message translates to:
  /// **'Your level'**
  String get yourLevel;

  /// No description provided for @beginnerLevel.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginnerLevel;

  /// No description provided for @speakTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speakTitle;

  /// No description provided for @speakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practice speaking with your AI tutor'**
  String get speakSubtitle;

  /// No description provided for @speakComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Speaking practice coming soon'**
  String get speakComingSoon;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get profileSettingsSub;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @vocabularyPathTitle.
  ///
  /// In en, this message translates to:
  /// **'{level} Vocabulary Path'**
  String vocabularyPathTitle(String level);

  /// No description provided for @vocabularyPathSub.
  ///
  /// In en, this message translates to:
  /// **'Learn 50 useful beginner words\nstep by step.'**
  String get vocabularyPathSub;

  /// No description provided for @grammarPathTitle.
  ///
  /// In en, this message translates to:
  /// **'{level} Grammar Path'**
  String grammarPathTitle(String level);

  /// No description provided for @grammarPathSub.
  ///
  /// In en, this message translates to:
  /// **'Learn simple grammar rules\nstep by step.'**
  String get grammarPathSub;

  /// No description provided for @readingPathTitle.
  ///
  /// In en, this message translates to:
  /// **'{level} Reading Path'**
  String readingPathTitle(String level);

  /// No description provided for @readingPathSub.
  ///
  /// In en, this message translates to:
  /// **'Read short English passages\nstep by step.'**
  String get readingPathSub;

  /// No description provided for @previousWord.
  ///
  /// In en, this message translates to:
  /// **'Previous Word'**
  String get previousWord;

  /// No description provided for @nextWord.
  ///
  /// In en, this message translates to:
  /// **'Next Word'**
  String get nextWord;

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'MEANING'**
  String get meaning;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'EXAMPLE'**
  String get example;

  /// No description provided for @wordIndex.
  ///
  /// In en, this message translates to:
  /// **'Word .{index}'**
  String wordIndex(int index);

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'{count} Words Learned'**
  String wordsLearned(int count);

  /// No description provided for @lessonCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have completed Lesson {number} \n successfully'**
  String lessonCompletedSuccess(int number);

  /// No description provided for @grammarLessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'You have completed Grammar Lesson {number} Successfully'**
  String grammarLessonCompleted(int number);

  /// No description provided for @readingLessonCompleted.
  ///
  /// In en, this message translates to:
  /// **'You have completed Reading Lesson {number} Successfully'**
  String readingLessonCompleted(int number);

  /// No description provided for @learnedUseOf.
  ///
  /// In en, this message translates to:
  /// **'You have learned the use of'**
  String get learnedUseOf;

  /// No description provided for @youHaveLearned.
  ///
  /// In en, this message translates to:
  /// **'You have learned'**
  String get youHaveLearned;

  /// No description provided for @quickTip.
  ///
  /// In en, this message translates to:
  /// **'Quick Tip'**
  String get quickTip;

  /// No description provided for @fluentaTip.
  ///
  /// In en, this message translates to:
  /// **'Fluenta Tip'**
  String get fluentaTip;

  /// No description provided for @playingWord.
  ///
  /// In en, this message translates to:
  /// **'Playing \"{word}\"...'**
  String playingWord(String word);

  /// No description provided for @wordSaved.
  ///
  /// In en, this message translates to:
  /// **'Word saved!'**
  String get wordSaved;

  /// No description provided for @wordRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved words'**
  String get wordRemoved;

  /// No description provided for @aiTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Tutor'**
  String get aiTutor;

  /// No description provided for @howToPracticeToday.
  ///
  /// In en, this message translates to:
  /// **'How do you want to\npractice today?'**
  String get howToPracticeToday;

  /// No description provided for @openChatPractice.
  ///
  /// In en, this message translates to:
  /// **'Open Chat Practice'**
  String get openChatPractice;

  /// No description provided for @openChatPracticeSub.
  ///
  /// In en, this message translates to:
  /// **'Free conversation with instant feedback'**
  String get openChatPracticeSub;

  /// No description provided for @startAiChat.
  ///
  /// In en, this message translates to:
  /// **'Start AI Chat'**
  String get startAiChat;

  /// No description provided for @roleplayScenarios.
  ///
  /// In en, this message translates to:
  /// **'Roleplay Scenarios'**
  String get roleplayScenarios;

  /// No description provided for @openingChatPractice.
  ///
  /// In en, this message translates to:
  /// **'Opening chat practice...'**
  String get openingChatPractice;

  /// No description provided for @selectedScenario.
  ///
  /// In en, this message translates to:
  /// **'Selected: {title}'**
  String selectedScenario(String title);

  /// No description provided for @lesson1DailyWords.
  ///
  /// In en, this message translates to:
  /// **'Daily Words'**
  String get lesson1DailyWords;

  /// No description provided for @lesson2WorkplaceWords.
  ///
  /// In en, this message translates to:
  /// **'Workplace Words'**
  String get lesson2WorkplaceWords;

  /// No description provided for @lesson3TravelWords.
  ///
  /// In en, this message translates to:
  /// **'Travel Words'**
  String get lesson3TravelWords;

  /// No description provided for @lesson1DailyRoutine.
  ///
  /// In en, this message translates to:
  /// **'Daily Routine'**
  String get lesson1DailyRoutine;

  /// No description provided for @lesson2OfficeDialogue.
  ///
  /// In en, this message translates to:
  /// **'Office Dialogue'**
  String get lesson2OfficeDialogue;

  /// No description provided for @lesson3TravelStory.
  ///
  /// In en, this message translates to:
  /// **'Travel Story'**
  String get lesson3TravelStory;

  /// No description provided for @lessonRestaurantTalk.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Talk'**
  String get lessonRestaurantTalk;

  /// No description provided for @lessonFamilyStory.
  ///
  /// In en, this message translates to:
  /// **'Family Story'**
  String get lessonFamilyStory;

  /// No description provided for @lessonShoppingStory.
  ///
  /// In en, this message translates to:
  /// **'Shopping Story'**
  String get lessonShoppingStory;

  /// No description provided for @lessonDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Doctor Visit'**
  String get lessonDoctorVisit;

  /// No description provided for @lessonWorkEmail.
  ///
  /// In en, this message translates to:
  /// **'Work Email'**
  String get lessonWorkEmail;

  /// No description provided for @lessonWeekendPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekend Plan'**
  String get lessonWeekendPlan;

  /// No description provided for @lessonDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get lessonDirections;

  /// No description provided for @lesson1IAmYouAre.
  ///
  /// In en, this message translates to:
  /// **'I am / you are'**
  String get lesson1IAmYouAre;

  /// No description provided for @lesson2PresentSimple.
  ///
  /// In en, this message translates to:
  /// **'Present Simple'**
  String get lesson2PresentSimple;

  /// No description provided for @lessonArticles.
  ///
  /// In en, this message translates to:
  /// **'A / an / The'**
  String get lessonArticles;

  /// No description provided for @lessonThisThat.
  ///
  /// In en, this message translates to:
  /// **'This / That'**
  String get lessonThisThat;

  /// No description provided for @lessonHeSheThey.
  ///
  /// In en, this message translates to:
  /// **'He / She / They'**
  String get lessonHeSheThey;

  /// No description provided for @lessonThereIsAre.
  ///
  /// In en, this message translates to:
  /// **'There is / There are'**
  String get lessonThereIsAre;

  /// No description provided for @lessonCanCannot.
  ///
  /// In en, this message translates to:
  /// **'Can / Cannot'**
  String get lessonCanCannot;

  /// No description provided for @lessonHaveHas.
  ///
  /// In en, this message translates to:
  /// **'Have / Has'**
  String get lessonHaveHas;

  /// No description provided for @lessonWasWere.
  ///
  /// In en, this message translates to:
  /// **'Was / Were'**
  String get lessonWasWere;

  /// No description provided for @lessonWillGoingTo.
  ///
  /// In en, this message translates to:
  /// **'Will / Going to'**
  String get lessonWillGoingTo;

  /// No description provided for @presentSimpleLearned.
  ///
  /// In en, this message translates to:
  /// **'Present Simple Learned'**
  String get presentSimpleLearned;

  /// No description provided for @officeDialogueLearned.
  ///
  /// In en, this message translates to:
  /// **'Office Dialogue Learned'**
  String get officeDialogueLearned;

  /// No description provided for @generalOfficeConversation.
  ///
  /// In en, this message translates to:
  /// **'General office conversation'**
  String get generalOfficeConversation;

  /// No description provided for @presentSimpleSummary.
  ///
  /// In en, this message translates to:
  /// **'He, she, it, I, you, we'**
  String get presentSimpleSummary;

  /// No description provided for @grammarStepIYouWe.
  ///
  /// In en, this message translates to:
  /// **'I You We'**
  String get grammarStepIYouWe;

  /// No description provided for @grammarStepIYouWeDesc.
  ///
  /// In en, this message translates to:
  /// **'Use the base verb with I, you, and we.'**
  String get grammarStepIYouWeDesc;

  /// No description provided for @grammarStepIYouWeFormula.
  ///
  /// In en, this message translates to:
  /// **'I / You / We + verb'**
  String get grammarStepIYouWeFormula;

  /// No description provided for @grammarStepHeSheIt.
  ///
  /// In en, this message translates to:
  /// **'He, She, It'**
  String get grammarStepHeSheIt;

  /// No description provided for @grammarStepHeSheItDesc.
  ///
  /// In en, this message translates to:
  /// **'With he, she, and it, add \'s\' to the verb.'**
  String get grammarStepHeSheItDesc;

  /// No description provided for @grammarStepHeSheItFormula.
  ///
  /// In en, this message translates to:
  /// **'He / She / It + verb + s'**
  String get grammarStepHeSheItFormula;

  /// No description provided for @grammarTipNoS.
  ///
  /// In en, this message translates to:
  /// **'Do not use \'s\' with i, you, we or they.'**
  String get grammarTipNoS;

  /// No description provided for @grammarTipNeedS.
  ///
  /// In en, this message translates to:
  /// **'He, she, and it usually need \'s\'.'**
  String get grammarTipNeedS;

  /// No description provided for @readingDialoguePart.
  ///
  /// In en, this message translates to:
  /// **'Dialogue Part {part}'**
  String readingDialoguePart(int part);

  /// No description provided for @readingManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get readingManager;

  /// No description provided for @readingYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get readingYou;

  /// No description provided for @readingManagerLine.
  ///
  /// In en, this message translates to:
  /// **'\"Can you join the meeting at 10?\"'**
  String get readingManagerLine;

  /// No description provided for @readingYouLine.
  ///
  /// In en, this message translates to:
  /// **'\"Yes, I can join the meeting.\"'**
  String get readingYouLine;

  /// No description provided for @readingFluentaTipText.
  ///
  /// In en, this message translates to:
  /// **'Try speaking the \'You\' response out loud to practice your office-ready pronunciation!'**
  String get readingFluentaTipText;

  /// No description provided for @levelA1.
  ///
  /// In en, this message translates to:
  /// **'A1'**
  String get levelA1;

  /// No description provided for @levelA2.
  ///
  /// In en, this message translates to:
  /// **'A2'**
  String get levelA2;

  /// No description provided for @levelB1.
  ///
  /// In en, this message translates to:
  /// **'B1'**
  String get levelB1;

  /// No description provided for @levelB2.
  ///
  /// In en, this message translates to:
  /// **'B2+'**
  String get levelB2;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi,'**
  String get hi;

  /// No description provided for @a1Beginner.
  ///
  /// In en, this message translates to:
  /// **'A1 Beginner'**
  String get a1Beginner;

  /// No description provided for @learningWithFluenta.
  ///
  /// In en, this message translates to:
  /// **'Learning English with Fluentta'**
  String get learningWithFluenta;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day {days}'**
  String dayStreak(int days);

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get progressLabel;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @heartsDaily.
  ///
  /// In en, this message translates to:
  /// **'{count} hearts daily'**
  String heartsDaily(int count);

  /// No description provided for @upgradePremiumDesc.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for unlimited AI practice, pronunciation checks, full roleplays, and no ads.'**
  String get upgradePremiumDesc;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @yourStats.
  ///
  /// In en, this message translates to:
  /// **'YOUR STATS'**
  String get yourStats;

  /// No description provided for @xpEarned.
  ///
  /// In en, this message translates to:
  /// **'XP earned'**
  String get xpEarned;

  /// No description provided for @wordsStat.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get wordsStat;

  /// No description provided for @lessonsStat.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsStat;

  /// No description provided for @correctionsStat.
  ///
  /// In en, this message translates to:
  /// **'Corrections'**
  String get correctionsStat;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @changeGoal.
  ///
  /// In en, this message translates to:
  /// **'Change Goal'**
  String get changeGoal;

  /// No description provided for @minPerDay.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min per day'**
  String minPerDay(int minutes);

  /// No description provided for @minToday.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} min today'**
  String minToday(int done, int total);

  /// No description provided for @settingsSection.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsSection;

  /// No description provided for @notificationsReminders.
  ///
  /// In en, this message translates to:
  /// **'Notifications & reminders'**
  String get notificationsReminders;

  /// No description provided for @dailyReminderAt.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder at {time}'**
  String dailyReminderAt(String time);

  /// No description provided for @appAppearance.
  ///
  /// In en, this message translates to:
  /// **'App Appearance'**
  String get appAppearance;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @supportLegal.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & LEGAL'**
  String get supportLegal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT ACTIONS'**
  String get accountActions;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutTitle;

  /// No description provided for @signOutSub.
  ///
  /// In en, this message translates to:
  /// **'Sign out from your account'**
  String get signOutSub;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSub.
  ///
  /// In en, this message translates to:
  /// **'Delete account permanently'**
  String get deleteAccountSub;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get allowNotifications;

  /// No description provided for @allowNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders and learning updates'**
  String get allowNotificationsSub;

  /// No description provided for @practiceReminders.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE REMINDERS'**
  String get practiceReminders;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @reminderTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeTitle;

  /// No description provided for @chooseReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Choose when you\'d like to practice every day.'**
  String get chooseReminderTime;

  /// No description provided for @saveReminder.
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @signOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get signOutQuestion;

  /// No description provided for @signOutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Your saved progress will stay safe. You will need to sign in again to sync and restore premium access'**
  String get signOutDialogMessage;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account, progress, saved words and learning history.'**
  String get deleteAccountDialogMessage;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Confirmation'**
  String get deleteAccountConfirmation;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @deleteWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'This action will permanently remove all your progress, stats, and personal data. This cannot be undone.'**
  String get deleteWarningMessage;

  /// No description provided for @understandPermanent.
  ///
  /// In en, this message translates to:
  /// **'I understand this action is permanent.'**
  String get understandPermanent;

  /// No description provided for @deleteAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountBtn;

  /// No description provided for @deleteMarketingNote.
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will also unsubscribe you from all marketing communications.'**
  String get deleteMarketingNote;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted'**
  String get accountDeleted;

  /// No description provided for @accountDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account and learning data have been deleted.'**
  String get accountDeletedMessage;

  /// No description provided for @sorryToSeeYouGo.
  ///
  /// In en, this message translates to:
  /// **'We are sorry to see you go'**
  String get sorryToSeeYouGo;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @createAccountAnytime.
  ///
  /// In en, this message translates to:
  /// **'You can create your account anytime.'**
  String get createAccountAnytime;

  /// No description provided for @englishExplanationsIn.
  ///
  /// In en, this message translates to:
  /// **'English explanations in {language}'**
  String englishExplanationsIn(String language);

  /// No description provided for @lessonsQuickLink.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsQuickLink;

  /// No description provided for @correctionsQuickLink.
  ///
  /// In en, this message translates to:
  /// **'Corrections'**
  String get correctionsQuickLink;

  /// No description provided for @openingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get openingSoon;

  /// No description provided for @upgradeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Premium upgrade coming soon'**
  String get upgradeComingSoon;

  /// No description provided for @restoringPurchases.
  ///
  /// In en, this message translates to:
  /// **'Restoring purchases...'**
  String get restoringPurchases;

  /// No description provided for @speakWithAiTutorTitle.
  ///
  /// In en, this message translates to:
  /// **'Speak With AI Tutor'**
  String get speakWithAiTutorTitle;

  /// No description provided for @aiSpeakingTutor.
  ///
  /// In en, this message translates to:
  /// **'AI Speaking Tutor'**
  String get aiSpeakingTutor;

  /// No description provided for @aiSpeakingTutorDesc.
  ///
  /// In en, this message translates to:
  /// **'Talk by voice or text and get instant corrections'**
  String get aiSpeakingTutorDesc;

  /// No description provided for @tagVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get tagVoice;

  /// No description provided for @tagText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get tagText;

  /// No description provided for @tagCorrections.
  ///
  /// In en, this message translates to:
  /// **'Corrections'**
  String get tagCorrections;

  /// No description provided for @pronunciationPractice.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation Practice'**
  String get pronunciationPractice;

  /// No description provided for @pronunciationPracticeSub.
  ///
  /// In en, this message translates to:
  /// **'Record voice and get feedback'**
  String get pronunciationPracticeSub;

  /// No description provided for @advertisement.
  ///
  /// In en, this message translates to:
  /// **'ADVERTISEMENT'**
  String get advertisement;

  /// No description provided for @bannerAdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Banner Ad Placeholder'**
  String get bannerAdPlaceholder;

  /// No description provided for @openAiChatPractice.
  ///
  /// In en, this message translates to:
  /// **'Open AI Chat Practice'**
  String get openAiChatPractice;

  /// No description provided for @pronunciation.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation'**
  String get pronunciation;

  /// No description provided for @pronunciationPracticeDesc.
  ///
  /// In en, this message translates to:
  /// **'Read a phrase, record your voice, and get feedback.'**
  String get pronunciationPracticeDesc;

  /// No description provided for @phraseOf.
  ///
  /// In en, this message translates to:
  /// **'Phrase {current} of {total}'**
  String phraseOf(int current, int total);

  /// No description provided for @speakClearly.
  ///
  /// In en, this message translates to:
  /// **'Speak clearly and naturally.'**
  String get speakClearly;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get startRecording;

  /// No description provided for @heartPerPronunciation.
  ///
  /// In en, this message translates to:
  /// **'1 heart per Pronunciation'**
  String get heartPerPronunciation;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'RECORDING...'**
  String get recording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// No description provided for @checkingPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Checking your pronunciation...'**
  String get checkingPronunciation;

  /// No description provided for @checkingPronunciationSub.
  ///
  /// In en, this message translates to:
  /// **'We\'re listening for clarity, rhythm, and word accuracy to provide your personalized feedback.'**
  String get checkingPronunciationSub;

  /// No description provided for @onlyTakesMoment.
  ///
  /// In en, this message translates to:
  /// **'This only takes a moment.'**
  String get onlyTakesMoment;

  /// No description provided for @greatEffort.
  ///
  /// In en, this message translates to:
  /// **'Great effort!'**
  String get greatEffort;

  /// No description provided for @pronunciationScoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Your pronunciation is clearer than {score}% of learners at your level. Keep it up!'**
  String pronunciationScoreMessage(int score);

  /// No description provided for @wordFeedback.
  ///
  /// In en, this message translates to:
  /// **'WORD FEEDBACK'**
  String get wordFeedback;

  /// No description provided for @confidencePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Confidence'**
  String confidencePercent(int percent);

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @nextPhrase.
  ///
  /// In en, this message translates to:
  /// **'Next Phrase'**
  String get nextPhrase;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice Complete'**
  String get practiceComplete;

  /// No description provided for @practicedPhrases.
  ///
  /// In en, this message translates to:
  /// **'You Practiced {count} pronunciation Phrases'**
  String practicedPhrases(int count);

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE SCORE'**
  String get averageScore;

  /// No description provided for @phrasesLabel.
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get phrasesLabel;

  /// No description provided for @bestWord.
  ///
  /// In en, this message translates to:
  /// **'Best word'**
  String get bestWord;

  /// No description provided for @practiceMore.
  ///
  /// In en, this message translates to:
  /// **'Practice More'**
  String get practiceMore;

  /// No description provided for @backToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Back to Speak'**
  String get backToSpeak;

  /// No description provided for @openChatPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Chat Practice'**
  String get openChatPracticeTitle;

  /// No description provided for @textMode.
  ///
  /// In en, this message translates to:
  /// **'Text Mode'**
  String get textMode;

  /// No description provided for @chatGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi! What would you like to practice today?'**
  String get chatGreeting;

  /// No description provided for @outOfHearts.
  ///
  /// In en, this message translates to:
  /// **'You\'re out of Hearts'**
  String get outOfHearts;

  /// No description provided for @outOfHeartsSub.
  ///
  /// In en, this message translates to:
  /// **'Fix Grammar, word choice, and sentences while you practice'**
  String get outOfHeartsSub;

  /// No description provided for @getMoreHearts.
  ///
  /// In en, this message translates to:
  /// **'GET MORE HEARTS'**
  String get getMoreHearts;

  /// No description provided for @goUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Go Unlimited'**
  String get goUnlimited;

  /// No description provided for @goUnlimitedSub.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI practice\nNo ads • Unlimited hearts'**
  String get goUnlimitedSub;

  /// No description provided for @watchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch Ad'**
  String get watchAd;

  /// No description provided for @watchAdSub.
  ///
  /// In en, this message translates to:
  /// **'Get +2 Hearts instantly'**
  String get watchAdSub;

  /// No description provided for @playingPhrase.
  ///
  /// In en, this message translates to:
  /// **'Playing phrase...'**
  String get playingPhrase;

  /// No description provided for @scenarioJobInterviews.
  ///
  /// In en, this message translates to:
  /// **'Job Interviews'**
  String get scenarioJobInterviews;

  /// No description provided for @scenarioOrderFood.
  ///
  /// In en, this message translates to:
  /// **'Order Food'**
  String get scenarioOrderFood;

  /// No description provided for @scenarioAtAirport.
  ///
  /// In en, this message translates to:
  /// **'At Airport'**
  String get scenarioAtAirport;

  /// No description provided for @scenarioDoctorVisit.
  ///
  /// In en, this message translates to:
  /// **'Doctor\'s Visit'**
  String get scenarioDoctorVisit;

  /// No description provided for @scenarioSmallTalk.
  ///
  /// In en, this message translates to:
  /// **'Small Talk'**
  String get scenarioSmallTalk;

  /// No description provided for @scenarioBusinessMeeting.
  ///
  /// In en, this message translates to:
  /// **'Business Meeting'**
  String get scenarioBusinessMeeting;

  /// No description provided for @learnAndPractice.
  ///
  /// In en, this message translates to:
  /// **'Learn & Practice'**
  String get learnAndPractice;

  /// No description provided for @quickCheck.
  ///
  /// In en, this message translates to:
  /// **'Quick Check'**
  String get quickCheck;

  /// No description provided for @quickCheckSub.
  ///
  /// In en, this message translates to:
  /// **'Answer comprehension questions'**
  String get quickCheckSub;

  /// No description provided for @roleplayPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} Practice'**
  String roleplayPracticeTitle(String title);

  /// No description provided for @scenarioJobInterviewDetail.
  ///
  /// In en, this message translates to:
  /// **'Job Interview'**
  String get scenarioJobInterviewDetail;

  /// No description provided for @scenarioJobInterviewVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key interview words'**
  String get scenarioJobInterviewVocabSub;

  /// No description provided for @scenarioOrderFoodDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Food'**
  String get scenarioOrderFoodDetail;

  /// No description provided for @scenarioOrderFoodVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key restaurant words'**
  String get scenarioOrderFoodVocabSub;

  /// No description provided for @scenarioAtAirportDetail.
  ///
  /// In en, this message translates to:
  /// **'At the Airport'**
  String get scenarioAtAirportDetail;

  /// No description provided for @scenarioAtAirportVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key travel words'**
  String get scenarioAtAirportVocabSub;

  /// No description provided for @scenarioDoctorVisitDetail.
  ///
  /// In en, this message translates to:
  /// **'Doctor Visit'**
  String get scenarioDoctorVisitDetail;

  /// No description provided for @scenarioDoctorVisitVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key medical words'**
  String get scenarioDoctorVisitVocabSub;

  /// No description provided for @scenarioSmallTalkDetail.
  ///
  /// In en, this message translates to:
  /// **'Small Talk'**
  String get scenarioSmallTalkDetail;

  /// No description provided for @scenarioSmallTalkVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key conversation words'**
  String get scenarioSmallTalkVocabSub;

  /// No description provided for @scenarioBusinessMeetingDetail.
  ///
  /// In en, this message translates to:
  /// **'Business Meeting'**
  String get scenarioBusinessMeetingDetail;

  /// No description provided for @scenarioBusinessMeetingVocabSub.
  ///
  /// In en, this message translates to:
  /// **'Learn key meeting words'**
  String get scenarioBusinessMeetingVocabSub;

  /// No description provided for @customPlanReady.
  ///
  /// In en, this message translates to:
  /// **'Your Custom plan is Ready'**
  String get customPlanReady;

  /// No description provided for @customPlanReadySub.
  ///
  /// In en, this message translates to:
  /// **'Based on your goal level & daily practice time.'**
  String get customPlanReadySub;

  /// No description provided for @planGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'GOAL'**
  String get planGoalLabel;

  /// No description provided for @planLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL'**
  String get planLevelLabel;

  /// No description provided for @planDailyLabel.
  ///
  /// In en, this message translates to:
  /// **'DAILY'**
  String get planDailyLabel;

  /// No description provided for @dailyMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String dailyMinutesShort(int minutes);

  /// No description provided for @includedInPlan.
  ///
  /// In en, this message translates to:
  /// **'Included in your plan'**
  String get includedInPlan;

  /// No description provided for @featureUnlimitedConversation.
  ///
  /// In en, this message translates to:
  /// **'Unlimited conversation'**
  String get featureUnlimitedConversation;

  /// No description provided for @featureUnlimitedGrammar.
  ///
  /// In en, this message translates to:
  /// **'Unlimited grammar corrections'**
  String get featureUnlimitedGrammar;

  /// No description provided for @featureAdvancedPronunciation.
  ///
  /// In en, this message translates to:
  /// **'Advanced pronunciation feedback'**
  String get featureAdvancedPronunciation;

  /// No description provided for @featurePersonalizedLessons.
  ///
  /// In en, this message translates to:
  /// **'Personalized work-English Lessons'**
  String get featurePersonalizedLessons;

  /// No description provided for @featureOfflineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get featureOfflineMode;

  /// No description provided for @annualPlan.
  ///
  /// In en, this message translates to:
  /// **'Annual Plan'**
  String get annualPlan;

  /// No description provided for @threeDayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'3-Day Free Trial'**
  String get threeDayFreeTrial;

  /// No description provided for @annualPrice.
  ///
  /// In en, this message translates to:
  /// **'\$39.99/yr'**
  String get annualPrice;

  /// No description provided for @annualPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'That\'s \$3.33/mo'**
  String get annualPricePerMonth;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'BEST VALUE'**
  String get bestValue;

  /// No description provided for @weeklyPlan.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weeklyPlan;

  /// No description provided for @weeklyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$4.99'**
  String get weeklyPrice;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPlan;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'\$12.99'**
  String get monthlyPrice;

  /// No description provided for @lifetimePlan.
  ///
  /// In en, this message translates to:
  /// **'Life Time'**
  String get lifetimePlan;

  /// No description provided for @lifetimePrice.
  ///
  /// In en, this message translates to:
  /// **'\$79.99'**
  String get lifetimePrice;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'One Time'**
  String get oneTime;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @needExtraHearts.
  ///
  /// In en, this message translates to:
  /// **'Need extra hearts?'**
  String get needExtraHearts;

  /// No description provided for @smallPack.
  ///
  /// In en, this message translates to:
  /// **'Small Pack'**
  String get smallPack;

  /// No description provided for @mediumPack.
  ///
  /// In en, this message translates to:
  /// **'Medium Pack'**
  String get mediumPack;

  /// No description provided for @largePack.
  ///
  /// In en, this message translates to:
  /// **'Large Pack'**
  String get largePack;

  /// No description provided for @heartsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Hearts'**
  String heartsCount(int count);

  /// No description provided for @startFreeTrialDays.
  ///
  /// In en, this message translates to:
  /// **'Start {days}-Day Free Trial'**
  String startFreeTrialDays(int days);

  /// No description provided for @cancelAnytimeNoCharge.
  ///
  /// In en, this message translates to:
  /// **'Cancel anytime. No charge today'**
  String get cancelAnytimeNoCharge;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @buyHeartsCount.
  ///
  /// In en, this message translates to:
  /// **'Buy {count} Hearts'**
  String buyHeartsCount(int count);

  /// No description provided for @heartsOneTimePurchase.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase. Hearts are added instantly.'**
  String get heartsOneTimePurchase;

  /// No description provided for @tryProForLess.
  ///
  /// In en, this message translates to:
  /// **'Try Pro for less'**
  String get tryProForLess;

  /// No description provided for @fiftyOffFirstYear.
  ///
  /// In en, this message translates to:
  /// **'50% off your first year- \$29 instead of \$59.99'**
  String get fiftyOffFirstYear;

  /// No description provided for @fiftyPercentOff.
  ///
  /// In en, this message translates to:
  /// **'50% OFF'**
  String get fiftyPercentOff;

  /// No description provided for @annualPro.
  ///
  /// In en, this message translates to:
  /// **'Annual Pro'**
  String get annualPro;

  /// No description provided for @annualProPrice.
  ///
  /// In en, this message translates to:
  /// **'\$29.99/year'**
  String get annualProPrice;

  /// No description provided for @annualProPriceStrikethrough.
  ///
  /// In en, this message translates to:
  /// **'\$59.99/year'**
  String get annualProPriceStrikethrough;

  /// No description provided for @firstYearOnly.
  ///
  /// In en, this message translates to:
  /// **'First year only'**
  String get firstYearOnly;

  /// No description provided for @sevenDayFreeTrialIncluded.
  ///
  /// In en, this message translates to:
  /// **'7-day free trial included'**
  String get sevenDayFreeTrialIncluded;

  /// No description provided for @specialOffer.
  ///
  /// In en, this message translates to:
  /// **'SPECIAL OFFER'**
  String get specialOffer;

  /// No description provided for @startSevenDayFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 7-Days Free Trial'**
  String get startSevenDayFreeTrial;

  /// No description provided for @heartsAddedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Hearts Added'**
  String heartsAddedTitle(int count);

  /// No description provided for @heartsAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your hearts have been added. You are ready for more AI chat, corrections, and practice.'**
  String get heartsAddedMessage;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @currentHeartsBalance.
  ///
  /// In en, this message translates to:
  /// **'{count} Hearts'**
  String currentHeartsBalance(int count);

  /// No description provided for @startPracticing.
  ///
  /// In en, this message translates to:
  /// **'Start Practicing'**
  String get startPracticing;

  /// No description provided for @oneHeartPerAiResponse.
  ///
  /// In en, this message translates to:
  /// **'1 heart per AI response'**
  String get oneHeartPerAiResponse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
