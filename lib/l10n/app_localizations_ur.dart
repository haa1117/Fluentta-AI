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
  String get levelB2 => 'B2+';
}
