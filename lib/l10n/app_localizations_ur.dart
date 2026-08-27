// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'فلوئینٹا';

  @override
  String get aiEnglishTutor => 'AI انگلش ٹیوٹر';

  @override
  String get speakWithAiTutor => 'اپنے AI ٹیوٹر کے ساتھ انگلش بولیں۔';

  @override
  String get next => 'اگلا';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get continueBtn => 'جاری رکھیں';

  @override
  String get getStarted => 'شروع کریں';

  @override
  String get open => 'کھولیں';

  @override
  String get start => 'شروع';

  @override
  String get previous => 'پچھلا';

  @override
  String get finishLesson => 'سبق مکمل کریں';

  @override
  String get startNextLesson => 'اگلا سبق شروع کریں';

  @override
  String lessonProgress(int number) {
    return 'سبق $number کی پیش رفت';
  }

  @override
  String lessonTitle(int number) {
    return 'سبق $number';
  }

  @override
  String get lessonPhase => 'سبق کا مرحلہ';

  @override
  String get completed => 'مکمل';

  @override
  String get inProgress => 'جاری ہے';

  @override
  String get locked => 'لاک';

  @override
  String get notStarted => 'شروع نہیں ہوا';

  @override
  String wordsProgress(int done, int total, String status) {
    return '$done/$total الفاظ • $status';
  }

  @override
  String lessonsCompleted(int done, int total) {
    return '$done / $total سبق مکمل';
  }

  @override
  String get completedLessonsReview =>
      'مکمل شدہ سبق دوبارہ دیکھنے کے لیے کھلے رہتے ہیں۔';

  @override
  String get lessonContentSoon => 'سبق کا مواد جلد آ رہا ہے';

  @override
  String openingCategory(String title) {
    return '$title کھولا جا رہا ہے...';
  }

  @override
  String get onboardingTitle1 => 'اپنے AI انگلش ٹیوٹر سے ملیں';

  @override
  String get onboardingDesc1 =>
      'اپنے ذاتی AI ٹیوٹر کے ساتھ چیٹ یا بول چال سے انگلش کی مشق کریں';

  @override
  String get onboardingTitle2 => 'فوری اصلاحات حاصل کریں';

  @override
  String get onboardingDesc2 => 'مشق کے دوران گرامر، الفاظ اور جملے درست کریں';

  @override
  String get onboardingTitle3 => 'ہر روز بہتر بنیں';

  @override
  String get onboardingDesc3 =>
      'روزانہ مشق اور آسان پیش رفت سے اپنی انگلش بنائیں';

  @override
  String get chooseYourLanguage => 'اپنی زبان منتخب کریں';

  @override
  String get personalizeExperience => 'ہم آپ کے سیکھنے کا تجربہ ذاتی بناتے ہیں';

  @override
  String get suggestedForYou => 'آپ کے لیے تجویز کردہ';

  @override
  String get otherLanguages => 'دیگر زبانیں';

  @override
  String get recommendedRegion => 'آپ کے علاقے کی بنیاد پر تجویز کردہ';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageEnglish => 'انگلش';

  @override
  String get languageSpanish => 'ہسپانوی';

  @override
  String get languageFrench => 'فرانسیسی';

  @override
  String get signInWithEmail => 'ای میل سے سائن ان';

  @override
  String get signInSubtitle => 'اپنا انگلش سیکھنے کا سفر جاری رکھیں۔';

  @override
  String get createAccount => 'اکاؤنٹ بنائیں';

  @override
  String get createAccountSubtitle =>
      'اپنی سیکھنے ki پیش رفت تمام ڈیوائسز پر محفوظ کریں';

  @override
  String get emailAddress => 'ای میل ایڈریس';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get fullName => 'پورا نام';

  @override
  String get enterYourName => 'اپنا نام درج کریں';

  @override
  String get minEightChars => 'کم از کم 8 حروف';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get signIn => 'سائن ان';

  @override
  String get alreadyHaveAccount => 'پہلے سے اکاؤنٹ ہے؟ ';

  @override
  String get rememberPassword => 'پاس ورڈ یاد ہے؟ ';

  @override
  String get forgotPasswordTitle => 'پاس ورڈ بھول گئے؟';

  @override
  String get forgotPasswordSubtitle =>
      'اپنے اکاؤنٹ سے منسلک ای میل درج کریں۔\n ہم آپ کو تصدیقی کوڈ بھیجیں گے۔';

  @override
  String get sendVerificationCode => 'تصدیقی کوڈ بھیجیں';

  @override
  String get verificationEmailSent => 'تصدیقی ای میل کامیابی سے بھیج دی گئی۔';

  @override
  String get checkYourEmail => 'اپنا ای میل چیک کریں';

  @override
  String otpSentTo(String email) {
    return 'ہم نے $email پر 4 ہندسوں کا کوڈ بھیجا ہے';
  }

  @override
  String get verifyCode => 'کوڈ کی تصدیق';

  @override
  String get verificationCodeResent => 'تصدیقی کوڈ دوبارہ بھیج دیا گیا۔';

  @override
  String get didntReceiveCode => 'کوڈ نہیں ملا؟ ';

  @override
  String get resetPassword => 'پاس ورڈ ری سیٹ';

  @override
  String get passwordUpdated => 'پاس ورڈ اپ ڈیٹ ہو گیا!';

  @override
  String get passwordUpdatedDesc =>
      'آپ کا پاس ورڈ کامیابی سے اپ ڈیٹ ہو گیا۔\nاب نئے پاس ورڈ سے سائن ان کریں';

  @override
  String get backToSignIn => 'سائن ان پر واپس';

  @override
  String get accountCreatedTitle => 'اکاؤنٹ بن گیا!';

  @override
  String get accountCreatedDesc =>
      'آپ کا اکاؤنٹ کامیابی سے بن گیا۔\nآئیے آپ کی سیکھنے ki ترجیحات سیٹ کریں۔';

  @override
  String get orContinueWith => 'یا اس کے ساتھ جاری رکھیں';

  @override
  String get dontHaveAccount => 'اکاؤنٹ نہیں ہے؟ ';

  @override
  String get newToFluenta => 'Fluenta میں نئے ہیں؟ ';

  @override
  String get continueWithGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get continueWithApple => 'Apple کے ساتھ جاری رکھیں';

  @override
  String get orLower => 'یا';

  @override
  String get createAccountButton => 'اکاؤنٹ بنائیں';

  @override
  String get createNewPasswordTitle => 'نیا پاس ورڈ بنائیں';

  @override
  String get createNewPasswordSubtitle =>
      'ایک محفوظ پاس ورڈ منتخب کریں جو آپ نے پہلے استعمال نہیں کیا';

  @override
  String get newPassword => 'نیا پاس ورڈ';

  @override
  String get enterNewPassword => 'نیا پاس ورڈ درج کریں';

  @override
  String get confirmNewPassword => 'نیا پاس ورڈ کی تصدیق';

  @override
  String get repeatPassword => 'پاس ورڈ دوبارہ درج کریں';

  @override
  String get updatePassword => 'پاس ورڈ اپ ڈیٹ کریں';

  @override
  String get accountCreatedSafeDesc =>
      'آپ ki پیش رفت اور سیکھنے کا plan\nمحفوظ طور پر محفوظ رہے گا۔';

  @override
  String get resendCode => 'کوڈ دوبارہ بھیجیں';

  @override
  String resendCodeIn(String time) {
    return '$time میں کوڈ دوبارہ بھیجیں';
  }

  @override
  String get creatingAccountTitle => 'آپ کا اکاؤنٹ بنایا جا رہا ہے...';

  @override
  String get creatingAccountSubtitle => 'براہ کرم تھوڑی دیر انتظار کریں۔';

  @override
  String get authErrorFillAllFields => 'براہ کرم تمام فیلڈز پُر کریں۔';

  @override
  String get authErrorPasswordMinEight =>
      'پاس ورڈ کم از کم 8 حروف کا ہونا چاہیے۔';

  @override
  String get authErrorInvalidEmail => 'براہ کرم درست ای میل درج کریں۔';

  @override
  String get authErrorUserDisabled => 'یہ اکاؤنٹ غیر فعال کر دیا گیا ہے۔';

  @override
  String get authErrorUserNotFound => 'اس ای میل سے کوئی اکاؤنٹ نہیں ملا۔';

  @override
  String get authErrorWrongPassword => 'غلط پاس ورڈ۔ دوبارہ کوشش کریں۔';

  @override
  String get authErrorEmailInUse => 'اس ای میل سے پہلے سے اکاؤنٹ موجود ہے۔';

  @override
  String get authErrorWeakPassword => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے۔';

  @override
  String get authErrorInvalidCredential => 'غلط ای میل یا پاس ورڈ۔';

  @override
  String get authErrorTooManyRequests =>
      'بہت زیادہ کوششیں۔ بعد میں دوبارہ کوشش کریں۔';

  @override
  String get authErrorNetwork => 'نیٹ ورک خرابی۔ اپنا کنکشن چیک کریں۔';

  @override
  String get authErrorOperationNotAllowed => 'یہ سائن ان طریقہ فعال نہیں ہے۔';

  @override
  String get authErrorInvalidVerificationCode => 'غلط تصدیقی کوڈ۔';

  @override
  String get authErrorExpiredActionCode =>
      'یہ ری سیٹ لنک ختم ہو گیا۔ نیا کوڈ مانگیں۔';

  @override
  String get authErrorInvalidActionCode => 'غلط ری سیٹ کوڈ۔ نیا کوڈ مانگیں۔';

  @override
  String get authErrorRequiresRecentLogin =>
      'پاس ورڈ اپ ڈیٹ کرنے کے لیے دوبارہ سائن ان کریں۔';

  @override
  String get authErrorGeneric => 'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔';

  @override
  String get authErrorPermissionDenied =>
      'پروفائل محفوظ نہیں ہو سکی۔ Firebase Console میں Firestore فعال کریں۔';

  @override
  String get authErrorUnavailable =>
      'Firestore دستیاب نہیں۔ انternet چیک کریں۔';

  @override
  String get authErrorNotFound =>
      'Firestore ڈیٹا بیس نہیں ملا۔ Firebase Console میں بنائیں۔';

  @override
  String get authErrorSaveFailed =>
      'صارف کا ڈیٹا محفوظ نہیں ہو سکا۔ دوبارہ کوشش کریں۔';

  @override
  String get setupGoalTitle => 'آپ کا انگلش مقصد کیا ہے؟';

  @override
  String get setupGoalSubtitle =>
      'آپ کا ٹیوٹر آپ کے مقصد کے مطابق مشق بنائے گا۔';

  @override
  String get setupLevelTitle => 'اپنا آغاز منتخب کریں';

  @override
  String get setupLevelSubtitle => 'ہم آپ کے لیول کے مطابق سبق ذاتی بنائیں گے۔';

  @override
  String get setupDailyTitle => 'روزانہ کا ہدف مقرر کریں';

  @override
  String get setupDailySubtitle =>
      'روزانہ چھوٹی مشق سے حقیقی انگلش فلوئنسی بنتی ہے۔';

  @override
  String get goalTravel => 'سفر';

  @override
  String get goalTravelSub => 'آسان مقامی گفتگو';

  @override
  String get goalWork => 'کام';

  @override
  String get goalWorkSub => 'کام کی جگہ کی انگلش';

  @override
  String get goalExam => 'امتحان';

  @override
  String get goalExamSub => 'IELTS، TOEFL اور انٹرویوز';

  @override
  String get goalEveryday => 'روزمرہ انگلش';

  @override
  String get goalEverydaySub => 'قدرتی گفتگو کی مشق';

  @override
  String get levelBeginner => 'ابتدائی';

  @override
  String get levelBeginnerSub => 'A1 · انگلش کی بنیادیں نئی';

  @override
  String get levelElementary => 'ابتدائی+';

  @override
  String get levelElementarySub => 'A2 · سادہ الفاظ استعمال کر سکتے ہیں';

  @override
  String get levelIntermediate => 'درمیانہ';

  @override
  String get levelIntermediateSub => 'B1 · سادہ گفتگو کر سکتے ہیں';

  @override
  String get levelUpperIntermediate => 'Upper-Intermediate';

  @override
  String get levelUpperIntermediateSub => 'B2 · روانی سے بات چیت';

  @override
  String get levelAdvancedC1 => 'Advanced';

  @override
  String get levelAdvancedC1Sub => 'C1 · روانی سے خیالات';

  @override
  String get levelProficientC2 => 'Proficient';

  @override
  String get levelProficientC2Sub => 'C2 · ماہر سطح';

  @override
  String get levelAdvanced => 'اعلیٰ';

  @override
  String get levelAdvancedSub => 'B2+ · زیادہ تر حالات میں آرام دہ';

  @override
  String get daily5 => '5 منٹ';

  @override
  String get daily5Sub => 'مصروف دنوں کے لیے بہترین';

  @override
  String get daily10 => '10 منٹ';

  @override
  String get daily10Sub => 'مسلسل پیش رفت کے لیے بہترین';

  @override
  String get daily15 => '15 منٹ';

  @override
  String get daily15Sub => 'زیادہ سیکھنے کے لیے';

  @override
  String get daily20 => '20 منٹ';

  @override
  String get daily20Sub => 'تیزی سے بہتری کے لیے';

  @override
  String get navHome => 'ہوم';

  @override
  String get navLearn => 'سیکھیں';

  @override
  String get navSpeak => 'بولیں';

  @override
  String get navProfile => 'پروفائل';

  @override
  String get readyToPractice => 'مشق کے لیے تیار؟';

  @override
  String get journeyContinues => 'آپ کا انگلش سفر یہاں جاری ہے۔';

  @override
  String get learnAndGrow => 'سیکھیں اور بڑھیں';

  @override
  String get vocabulary => 'ذخیرہ الفاظ';

  @override
  String get vocabularySub => '5 الفاظ دیکھنے ہیں';

  @override
  String vocabularySubDynamic(int count) {
    return '$count الفاظ دوبارہ دیکھنے ہیں';
  }

  @override
  String get grammar => 'گرامر';

  @override
  String get grammarSub => 'فوری مشق';

  @override
  String get reading => 'پڑھنا';

  @override
  String get readingSub => 'مختصر پیرا';

  @override
  String get savedWords => 'محفوظ الفاظ';

  @override
  String get savedWordsSub => '12 الفاظ دیکھنے ہیں';

  @override
  String savedWordsSubDynamic(int count) {
    return '$count محفوظ الفاظ';
  }

  @override
  String get dailyVocabulary => 'روزانہ الفاظ';

  @override
  String dailyVocabularySub(int count) {
    return '5 نئے الفاظ • $count دوبارہ دیکھنے';
  }

  @override
  String dailyVocabularyDoneSub(int count) {
    return 'آج مکمل • $count دوبارہ دیکھنے';
  }

  @override
  String get freeAndUnlimited => 'مفت اور لامحدود';

  @override
  String get startDailyVocabulary => 'روزانہ الفاظ شروع کریں';

  @override
  String get todaysWords => 'آج کے الفاظ';

  @override
  String todaysWordsDesc(int count) {
    return 'آج کے لیے $count نئے الفاظ سیکھیں۔';
  }

  @override
  String get dailyVocabularyComplete => 'روزانہ الفاظ مکمل!';

  @override
  String get learnTodaysWords => 'آج کے الفاظ سیکھیں';

  @override
  String get reviewTodaysWordsAgain => 'آج کے الفاظ دوبارہ مشق کریں';

  @override
  String get spacedRepetitionReview => 'وقفے وار دہرائی';

  @override
  String spacedRepetitionReviewDesc(int count) {
    return '$count الفاظ دوبارہ دیکھنے کے لیے تیار ہیں۔';
  }

  @override
  String reviewWords(int count) {
    return 'الفاظ دوبارہ ($count)';
  }

  @override
  String get reviewSession => 'دہرائی سیشن';

  @override
  String get revealMeaning => 'معنی دکھائیں';

  @override
  String get howWellDidYouKnow => 'آپ کو یہ لفظ کتنا آتا تھا؟';

  @override
  String get srsAgain => 'دوبارہ';

  @override
  String get srsGood => 'اچھا';

  @override
  String get srsEasy => 'آسان';

  @override
  String get reviewSessionComplete => 'دہرائی مکمل!';

  @override
  String get noSavedWords =>
      'ابھی کوئی لفظ محفوظ نہیں۔ سیکھتے وقت بک مارک دبائیں۔';

  @override
  String wordProgress(int current, int total) {
    return 'لفظ $current از $total';
  }

  @override
  String get meaningLabel => 'معنی';

  @override
  String get exampleLabel => 'مثال';

  @override
  String get yourLevel => 'آپ کا لیول';

  @override
  String get beginnerLevel => 'ابتدائی';

  @override
  String get speakTitle => 'بولیں';

  @override
  String get speakSubtitle => 'AI ٹیوٹر کے ساتھ بولنے ki مشق';

  @override
  String get speakComingSoon => 'بولنے ki مشق جلد آ رہی ہے';

  @override
  String get profileLanguage => 'زبان';

  @override
  String get profileSettings => 'ترتیبات';

  @override
  String get profileSettingsSub => 'ایپ ki ترجیحات';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get user => 'صارف';

  @override
  String get changeLanguage => 'زبان تبدیل کریں';

  @override
  String vocabularyPathTitle(String level) {
    return '$level ذخیرہ الفاظ کا راستہ';
  }

  @override
  String get vocabularyPathSub => '50 مفید ابتدائی الفاظ\nمرحلہ وار سیکھیں۔';

  @override
  String grammarPathTitle(String level) {
    return '$level گرامر کا راستہ';
  }

  @override
  String get grammarPathSub => 'آسان گرامر قوانین\nمرحلہ وار سیکھیں۔';

  @override
  String readingPathTitle(String level) {
    return '$level پڑھنے کا راستہ';
  }

  @override
  String get readingPathSub => 'مختصر انگلش پیرے\nمرحلہ وار پڑھیں۔';

  @override
  String get previousWord => 'پچھلا لفظ';

  @override
  String get nextWord => 'اگلا لفظ';

  @override
  String get listen => 'سنیں';

  @override
  String get save => 'محفوظ';

  @override
  String get meaning => 'معنی';

  @override
  String get example => 'مثال';

  @override
  String wordIndex(int index) {
    return 'لفظ .$index';
  }

  @override
  String wordsLearned(int count) {
    return '$count الفاظ سیکھے';
  }

  @override
  String lessonCompletedSuccess(int number) {
    return 'آپ نے سبق $number \n کامیابی سے مکمل کیا';
  }

  @override
  String grammarLessonCompleted(int number) {
    return 'آپ نے گرامر سبق $number کامیابی سے مکمل کیا';
  }

  @override
  String readingLessonCompleted(int number) {
    return 'آپ نے پڑھنے کا سبق $number کامیابی سے مکمل کیا';
  }

  @override
  String get learnedUseOf => 'آپ نے استعمال سیکھ لیا';

  @override
  String get youHaveLearned => 'آپ نے سیکھ لیا';

  @override
  String get quickTip => 'فوری مشورہ';

  @override
  String get fluentaTip => 'فلوئینٹا مشورہ';

  @override
  String playingWord(String word) {
    return '\"$word\" چلایا جا رہا ہے...';
  }

  @override
  String get wordSaved => 'لفظ محفوظ!';

  @override
  String get wordRemoved => 'محفوظ الفاظ سے ہٹایا گیا';

  @override
  String get listenUnavailable => 'اس ڈیوائس پر آڈیو چلانا دستیاب نہیں ہے۔';

  @override
  String get aiTutor => 'AI ٹیوٹر';

  @override
  String get howToPracticeToday => 'آج آپ کس طرح\nمشق کرنا چاہتے ہیں؟';

  @override
  String get openChatPractice => 'چیٹ مشق کھولیں';

  @override
  String get openChatPracticeSub => 'فوری فیڈبیک کے ساتھ آزاد گفتگو';

  @override
  String get startAiChat => 'AI چیٹ شروع کریں';

  @override
  String get roleplayScenarios => 'رول پلے منظرنامے';

  @override
  String get openingChatPractice => 'چیٹ مشق کھولی جا رہی ہے...';

  @override
  String selectedScenario(String title) {
    return 'منتخب: $title';
  }

  @override
  String get lesson1DailyWords => 'روزمرہ الفاظ';

  @override
  String get lesson2WorkplaceWords => 'کام کی جگہ کے الفاظ';

  @override
  String get lesson3TravelWords => 'سفر کے الفاظ';

  @override
  String get lesson1DailyRoutine => 'روزمرہ معمول';

  @override
  String get lesson2OfficeDialogue => 'دفتر کی گفتگو';

  @override
  String get lesson3TravelStory => 'سفر ki کہانی';

  @override
  String get lessonRestaurantTalk => 'ریستوران ki گفتگو';

  @override
  String get lessonFamilyStory => 'خاندان ki کہانی';

  @override
  String get lessonShoppingStory => 'خریداری ki کہانی';

  @override
  String get lessonDoctorVisit => 'ڈاکٹر کا دورہ';

  @override
  String get lessonWorkEmail => 'کام کا ای میل';

  @override
  String get lessonWeekendPlan => 'ویک اینڈ کا منصوبہ';

  @override
  String get lessonDirections => 'سمتیں';

  @override
  String get lesson1IAmYouAre => 'میں ہوں / تم ہو';

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
  String get presentSimpleLearned => 'Present Simple سیکھ لیا';

  @override
  String get officeDialogueLearned => 'دفتر ki گفتگو سیکh li';

  @override
  String get generalOfficeConversation => 'عام دفتر ki گفتگو';

  @override
  String get presentSimpleSummary => 'He, she, it, I, you, we';

  @override
  String get grammarStepIYouWe => 'I You We';

  @override
  String get grammarStepIYouWeDesc =>
      'I، you اور we کے ساتھ بنیادی فعل استعمال کریں۔';

  @override
  String get grammarStepIYouWeFormula => 'I / You / We + verb';

  @override
  String get grammarStepHeSheIt => 'He, She, It';

  @override
  String get grammarStepHeSheItDesc =>
      'he، she اور it کے ساتھ فعل میں \'s\' شامل کریں۔';

  @override
  String get grammarStepHeSheItFormula => 'He / She / It + verb + s';

  @override
  String get grammarTipNoS =>
      'i، you، we یا they کے ساتھ \'s\' استعمال نہ کریں۔';

  @override
  String get grammarTipNeedS => 'he، she اور it کو عام طور پر \'s\' چاہیے۔';

  @override
  String readingDialoguePart(int part) {
    return 'گفتگو حصہ $part';
  }

  @override
  String readingPassagePart(int part) {
    return 'پڑھائی حصہ $part';
  }

  @override
  String get readingManager => 'مینیجر';

  @override
  String get readingYou => 'آپ';

  @override
  String get readingManagerLine => '\"Can you join the meeting at 10?\"';

  @override
  String get readingYouLine => '\"Yes, I can join the meeting.\"';

  @override
  String get readingFluentaTipText =>
      '\'You\' کا جواب بلند آواز se بول کر دفتر ki تیاری ki مشق کریں!';

  @override
  String get levelA1 => 'A1';

  @override
  String get levelA2 => 'A2';

  @override
  String get levelB1 => 'B1';

  @override
  String get levelB2 => 'B2';

  @override
  String get levelC1 => 'C1';

  @override
  String get levelC2 => 'C2';

  @override
  String get profileTitle => 'پروفائل';

  @override
  String get hi => 'سلام،';

  @override
  String get a1Beginner => 'A1 ابتدائی';

  @override
  String get learningWithFluenta => 'فلوئینٹا کے ساتھ انگلش سیکھ رہے ہیں';

  @override
  String dayStreak(int days) {
    return 'دن $days';
  }

  @override
  String get progressLabel => 'پیش رفت';

  @override
  String get freePlan => 'مفت پلان';

  @override
  String heartsDaily(int count) {
    return 'روزانہ $count دل';
  }

  @override
  String get upgradePremiumDesc =>
      'لامحدود AI مشق، تلفظ کی جانچ، مکمل رول پلے اور بغیر اشتہارات کے اپ گریڈ کریں۔';

  @override
  String get upgradeToPremium => 'پریمیم میں اپ گریڈ';

  @override
  String get yourStats => 'آپ کے اعداد و شمار';

  @override
  String get xpEarned => 'XP حاصل';

  @override
  String get wordsStat => 'الفاظ';

  @override
  String get lessonsStat => 'سبق';

  @override
  String get correctionsStat => 'اصلاحات';

  @override
  String get dailyGoal => 'روزانہ ہدف';

  @override
  String get changeGoal => 'ہدف تبدیل کریں';

  @override
  String minPerDay(int minutes) {
    return 'روزانہ $minutes منٹ';
  }

  @override
  String minToday(int done, int total) {
    return 'آج $done / $total منٹ';
  }

  @override
  String get settingsSection => 'ترتیبات';

  @override
  String get learningPreferences => 'سیکھنے کی ترجیحات';

  @override
  String get learningPreferencesSub =>
      'مقصد، لیول اور روزانہ ہدف دوبارہ منتخب کریں';

  @override
  String get savePreferences => 'ترجیحات محفوظ کریں';

  @override
  String get setupSaved => 'آپ کی ترجیحات اپ ڈیٹ ہو گئیں';

  @override
  String get notificationsReminders => 'اطلاعات اور یاد دہانیاں';

  @override
  String dailyReminderAt(String time) {
    return 'روزانہ یاد دہانی $time بجے';
  }

  @override
  String get appAppearance => 'ایپ کی ظاہری شکل';

  @override
  String get lightMode => 'لائٹ موڈ';

  @override
  String get restorePurchases => 'خریداری بحال کریں';

  @override
  String get supportLegal => 'مدد اور قانونی';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get termsOfUse => 'استعمال کی شرائط';

  @override
  String get contactSupport => 'سپورٹ سے رابطہ';

  @override
  String get rateApp => 'ایپ کو ریٹ کریں';

  @override
  String get accountActions => 'اکاؤنٹ کے اقدامات';

  @override
  String get signOutTitle => 'سائن آؤٹ';

  @override
  String get signOutSub => 'اپنے اکاؤنٹ سے سائن آؤٹ کریں';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteAccountSub => 'اکاؤنٹ مستقل طور پر حذف کریں';

  @override
  String get allowNotifications => 'اطلاعات کی اجازت';

  @override
  String get allowNotificationsSub =>
      'یاد دہانیاں اور سیکھنے کی اپ ڈیٹس حاصل کریں';

  @override
  String get practiceReminders => 'مشق کی یاد دہانیاں';

  @override
  String get dailyReminder => 'روزانہ یاد دہانی';

  @override
  String get reminderTime => 'یاد دہانی کا وقت';

  @override
  String get reminderTimeTitle => 'یاد دہانی کا وقت';

  @override
  String get chooseReminderTime => 'ہر روز مشق کا وقت منتخب کریں۔';

  @override
  String get saveReminder => 'یاد دہانی محفوظ کریں';

  @override
  String get cancelBtn => 'منسوخ';

  @override
  String get signOutQuestion => 'سائن آؤٹ؟';

  @override
  String get signOutDialogMessage =>
      'آپ ki محفوظ پیش رفت محفوظ رہے گی۔ مطابقت اور پریمیم رسائی بحال کرنے کے لیے دوبارہ سائن ان کرنا ہوگا';

  @override
  String get exitAppQuestion => 'Fluenta سے باہر نکلیں؟';

  @override
  String get exitAppMessage =>
      'آپ ki پیش رفت محفوظ ہے۔ سیکھنا جاری رکھنے کے لیے کبھی بھی واپس آئیں۔';

  @override
  String get keepLearning => 'سیکھنا جاری رکھیں';

  @override
  String get exitApp => 'ایپ بند کریں';

  @override
  String get deleteAccountQuestion => 'اکاؤنٹ حذف کریں؟';

  @override
  String get deleteAccountDialogMessage =>
      'یہ آپ کا اکاؤنٹ، پیش رفت، محفوظ الفاظ اور سیکھنے ki تاریخ مستقل طور پر حذف کر دے گا۔';

  @override
  String get deleteAccountConfirmation => 'اکاؤنٹ حذف ki تصدیق';

  @override
  String get warning => 'انتباہ';

  @override
  String get deleteWarningMessage =>
      'یہ عمل آپ ki تمام پیش رفت، اعداد و شمار اور ذاتی ڈیٹا مستقل طور پر حذف کر دے گا۔ یہ واپس نہیں ہو سکتا۔';

  @override
  String get understandPermanent => 'میں سمجھتا/سمجھتی ہوں کہ یہ عمل مستقل ہے۔';

  @override
  String get deleteAccountBtn => 'اکاؤنٹ حذف کریں';

  @override
  String get deleteMarketingNote =>
      'اکاؤنٹ حذف کرنے سے آپ تمام مارکیٹنگ مواصلات سے بھی ان سبسکرائب ہو جائیں گے۔';

  @override
  String get accountDeleted => 'اکاؤنٹ حذف ہو گیا';

  @override
  String get accountDeletedMessage =>
      'آپ کا اکاؤنٹ اور سیکھنے کا ڈیٹا حذف کر دیا گیا ہے۔';

  @override
  String get sorryToSeeYouGo => 'آپ ko جاتے دیکh kar افسوس ہے';

  @override
  String get done => 'مکمل';

  @override
  String get createAccountAnytime => 'آپ کسی بھی وقت نیا اکاؤنٹ بنا سکتے ہیں۔';

  @override
  String englishExplanationsIn(String language) {
    return '$language میں انگلش وضاحتیں';
  }

  @override
  String get lessonsQuickLink => 'سبق';

  @override
  String get correctionsQuickLink => 'اصلاحات';

  @override
  String get openingSoon => 'جلد آ رہا ہے';

  @override
  String get upgradeComingSoon => 'پریمیم اپ گریڈ جلد آ رہا ہے';

  @override
  String get restoringPurchases => 'خریداری بحال ki ja rahi hai...';

  @override
  String get speakWithAiTutorTitle => 'AI ٹیوٹر کے ساتھ بولیں';

  @override
  String get aiSpeakingTutor => 'AI Speaking Tutor';

  @override
  String get aiSpeakingTutorDesc =>
      'آواز یا ٹیکسٹ سے بات کریں اور فوری اصلاحات حاصل کریں';

  @override
  String get tagVoice => 'آواز';

  @override
  String get tagText => 'ٹیکسٹ';

  @override
  String get tagCorrections => 'اصلاحات';

  @override
  String get pronunciationPractice => 'تلفظ کی مشق';

  @override
  String get pronunciationPracticeSub =>
      'آواز ریکارڈ کریں اور فیڈبیک حاصل کریں';

  @override
  String get advertisement => 'اشتہار';

  @override
  String get bannerAdPlaceholder => ' بینر اشتہار';

  @override
  String get openAiChatPractice => 'AI چیٹ مشق کھولیں';

  @override
  String get pronunciation => 'تلفظ';

  @override
  String get pronunciationPracticeDesc =>
      'ایک جملہ پڑھیں، اپنی آواز ریکارڈ کریں اور فیڈبیک حاصل کریں۔';

  @override
  String phraseOf(int current, int total) {
    return 'جملہ $current / $total';
  }

  @override
  String get speakClearly => 'واضح اور قدرتی بولیں۔';

  @override
  String get startRecording => 'ریکارڈنگ شروع کریں';

  @override
  String get heartPerPronunciation => '❤️ 1 دل فی تلفظ';

  @override
  String get recording => 'ریکارڈنگ...';

  @override
  String get stopRecording => 'ریکارڈنگ بند کریں';

  @override
  String get checkingPronunciation => 'آپ کا تلفظ چیک کیا جا رہا ہے...';

  @override
  String get checkingPronunciationSub =>
      'ہم وضاحت، لے اور الفاظ کی درستگی سن رہے ہیں تاکہ ذاتی فیڈبیک دے سکیں۔';

  @override
  String get onlyTakesMoment => 'یہ صرف ایک لمحہ لے گا۔';

  @override
  String get greatEffort => 'بہترین کوشش!';

  @override
  String pronunciationScoreMessage(int score) {
    return 'آپ کا تلفظ آپ کے لیول کے 85% سیکھنے والوں سے بہتر ہے۔ جاری رکھیں!';
  }

  @override
  String get wordFeedback => 'لفظ کی فیڈبیک';

  @override
  String confidencePercent(int percent) {
    return '$percent% اعتماد';
  }

  @override
  String heardAs(String word) {
    return 'سuna: \"$word\"';
  }

  @override
  String focusOnSounds(String sounds) {
    return 'توجہ دیں: $sounds';
  }

  @override
  String youSaid(String transcript) {
    return 'آپ نے کہا: \"$transcript\"';
  }

  @override
  String get noSpeechDetected =>
      'واضح آواز نہیں ملی۔ زور سے بولیں اور دوبارہ کوشش کریں۔';

  @override
  String get tryAgain => 'دوبارہ کوشش';

  @override
  String get nextPhrase => 'اگلا جملہ';

  @override
  String get finish => 'ختم';

  @override
  String get practiceComplete => 'مشق مکمل';

  @override
  String practicedPhrases(int count) {
    return 'آپ نے $count تلفظ کے جملے مشق کیے';
  }

  @override
  String get averageScore => 'اوسط اسکور';

  @override
  String get phrasesLabel => 'جملے';

  @override
  String get bestWord => 'بہترین لفظ';

  @override
  String get practiceMore => 'مزید مشق';

  @override
  String get backToSpeak => 'Speak پر واپس';

  @override
  String get openChatPracticeTitle => 'چیٹ مشق کھولیں';

  @override
  String get textMode => 'ٹیکسٹ موڈ';

  @override
  String get chatGreeting => 'سلام! آج آپ کیا مشق کرنا چاہتے ہیں؟';

  @override
  String get outOfHearts => 'آپ کے دل ختم ہو گئے';

  @override
  String get outOfHeartsSub => 'مشق کے دوران گرامر، الفاظ اور جملے درست کریں';

  @override
  String get getMoreHearts => 'مزید دل حاصل کریں';

  @override
  String get goUnlimited => 'لامحدود بنیں';

  @override
  String get goUnlimitedSub => 'لامحدود AI مشق\nبغیر اشتہارات • لامحدود دل';

  @override
  String get watchAd => 'اشتہار دیکھیں';

  @override
  String get watchAdSub => 'فوری +2 دل حاصل کریں';

  @override
  String get playingPhrase => 'جملہ چلایا جا رہا ہے...';

  @override
  String get pronunciationUnavailable =>
      'اس ڈیوائس پر مائیک یا speech recognition دستیاب نہیں ہے۔';

  @override
  String get microphonePermissionDenied =>
      'تلفظ کی مشق کے لیے مائیک کی اجازت درکار ہے۔';

  @override
  String get scenarioJobInterviews => 'نوکری کے انٹرویو';

  @override
  String get scenarioOrderFood => 'کھانا آرڈر';

  @override
  String get scenarioAtAirport => 'ہوائی اڈے پر';

  @override
  String get scenarioDoctorVisit => 'ڈاکٹر کا دورہ';

  @override
  String get scenarioSmallTalk => 'Small Talk';

  @override
  String get scenarioBusinessMeeting => 'Business Meeting';

  @override
  String get learnAndPractice => 'سیکھیں اور مشق کریں';

  @override
  String get quickCheck => 'فوری جانچ';

  @override
  String get quickCheckSub => 'سمجھ کے سوالات کے جواب دیں';

  @override
  String roleplayPracticeTitle(String title) {
    return '$title مشق';
  }

  @override
  String get scenarioJobInterviewDetail => 'نوکری کا انٹرویو';

  @override
  String get scenarioJobInterviewVocabSub => 'انٹرویو کے اہم الفاظ سیکھیں';

  @override
  String get scenarioOrderFoodDetail => 'کھانا آرڈر';

  @override
  String get scenarioOrderFoodVocabSub => 'ریستوران کے اہم الفاظ سیکھیں';

  @override
  String get scenarioAtAirportDetail => 'ہوائی اڈے پر';

  @override
  String get scenarioAtAirportVocabSub => 'سفر کے اہم الفاظ سیکھیں';

  @override
  String get scenarioDoctorVisitDetail => 'ڈاکٹر کا دورہ';

  @override
  String get scenarioDoctorVisitVocabSub => 'طبی اہم الفاظ سیکھیں';

  @override
  String get scenarioSmallTalkDetail => 'Small Talk';

  @override
  String get scenarioSmallTalkVocabSub => 'بات چیت کے اہم الفاظ سیکھیں';

  @override
  String get scenarioBusinessMeetingDetail => 'Business Meeting';

  @override
  String get scenarioBusinessMeetingVocabSub => 'میeting کے اہم الفاظ سیکھیں';

  @override
  String get scenarioJobInterviewQuickSub => 'Answer job interview questions';

  @override
  String get scenarioOrderFoodQuickSub => 'Answer restaurant questions';

  @override
  String get scenarioAtAirportQuickSub => 'Answer airport travel questions';

  @override
  String get scenarioDoctorVisitQuickSub => 'Answer doctor visit questions';

  @override
  String get scenarioSmallTalkQuickSub => 'Answer small talk questions';

  @override
  String get scenarioBusinessMeetingQuickSub =>
      'Answer business meeting questions';

  @override
  String roleplayQuestionsLearned(int count) {
    return '$count Questions Learned';
  }

  @override
  String roleplayLessonCompleted(int lessonNumber) {
    return 'You have completed Lesson $lessonNumber successfully';
  }

  @override
  String get customPlanReady => 'آپ کا Custom plan تیار ہے';

  @override
  String get customPlanReadySub =>
      'آپ کے goal، level اور روزانہ practice time کی بنیاد پر۔';

  @override
  String get planGoalLabel => 'GOAL';

  @override
  String get planLevelLabel => 'LEVEL';

  @override
  String get planDailyLabel => 'DAILY';

  @override
  String dailyMinutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String get includedInPlan => 'آپ کے plan میں شامل';

  @override
  String get featureUnlimitedConversation => 'لامحدود conversation';

  @override
  String get featureUnlimitedGrammar => 'لامحدود grammar corrections';

  @override
  String get featureAdvancedPronunciation => 'Advanced pronunciation feedback';

  @override
  String get featurePersonalizedLessons => 'Personalized work-English Lessons';

  @override
  String get featureOfflineMode => 'Offline mode';

  @override
  String get annualPlan => 'Annual Plan';

  @override
  String get threeDayFreeTrial => '3-Day Free Trial';

  @override
  String get annualPrice => '\$39.99/yr';

  @override
  String get annualPricePerMonth => 'That\'s \$3.33/mo';

  @override
  String get bestValue => 'BEST VALUE';

  @override
  String get weeklyPlan => 'Weekly';

  @override
  String get weeklyPrice => '\$4.99';

  @override
  String get monthlyPlan => 'Monthly';

  @override
  String get monthlyPrice => '\$12.99';

  @override
  String get lifetimePlan => 'Life Time';

  @override
  String get lifetimePrice => '\$79.99';

  @override
  String get oneTime => 'One Time';

  @override
  String get orDivider => 'OR';

  @override
  String get needExtraHearts => 'مزید hearts چاہیے؟';

  @override
  String get smallPack => 'Small Pack';

  @override
  String get mediumPack => 'Medium Pack';

  @override
  String get largePack => 'Large Pack';

  @override
  String heartsCount(int count) {
    return '$count Hearts';
  }

  @override
  String startFreeTrialDays(int days) {
    return 'Start $days-Day Free Trial';
  }

  @override
  String get cancelAnytimeNoCharge => 'Cancel anytime. No charge today';

  @override
  String get terms => 'Terms';

  @override
  String get privacy => 'Privacy';

  @override
  String get restore => 'Restore';

  @override
  String buyHeartsCount(int count) {
    return 'Buy $count Hearts';
  }

  @override
  String get heartsOneTimePurchase =>
      'One-time purchase. Hearts are added instantly.';

  @override
  String get tryProForLess => 'Try Pro for less';

  @override
  String get fiftyOffFirstYear =>
      '50% off your first year- \$29 instead of \$59.99';

  @override
  String get fiftyPercentOff => '50% OFF';

  @override
  String get annualPro => 'Annual Pro';

  @override
  String get annualProPrice => '\$29.99/year';

  @override
  String get annualProPriceStrikethrough => '\$59.99/year';

  @override
  String get firstYearOnly => 'First year only';

  @override
  String get sevenDayFreeTrialIncluded => '7-day free trial included';

  @override
  String get specialOffer => 'SPECIAL OFFER';

  @override
  String get startSevenDayFreeTrial => 'Start 7-Days Free Trial';

  @override
  String heartsAddedTitle(int count) {
    return '$count Hearts Added';
  }

  @override
  String get heartsAddedMessage =>
      'Your hearts have been added. You are ready for more AI chat, corrections, and practice.';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String currentHeartsBalance(int count) {
    return '$count Hearts';
  }

  @override
  String get startPracticing => 'Start Practicing';

  @override
  String get oneHeartPerAiResponse => '1 heart per AI response';
}
