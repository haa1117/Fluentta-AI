import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/app_navigator.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_theme.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_sync_repository.dart';
import 'package:fluentta_ai/data/repositories/daily_vocabulary_repository.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/repositories/spaced_repetition_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/viewmodels/grammar_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/viewmodels/subscription_view_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_view_model.dart';
import 'package:provider/provider.dart';
import 'package:fluentta_ai/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localStorage = await LocalStorage.getInstance();
  final userRepository = UserRepository(localStorage);
  final authRepository = AuthRepository(localStorage, userRepository);
  final lessonContentRepository = LessonContentRepository();
  final progressRepository = ProgressRepository(localStorage);
  final progressSyncRepository = ProgressSyncRepository();
  final savedWordsRepository = SavedWordsRepository(localStorage);
  final spacedRepetitionRepository = SpacedRepetitionRepository(localStorage);
  final dailyVocabularyRepository = DailyVocabularyRepository(
    localStorage,
    lessonContentRepository,
  );
  final progressSyncService = ProgressSyncService(
    progressRepository: progressRepository,
    syncRepository: progressSyncRepository,
    userRepository: userRepository,
    localStorage: localStorage,
  );
  final textToSpeechService = TextToSpeechService();
  final pronunciationAssessmentService = PronunciationAssessmentService();

  await lessonContentRepository.initialize();
  await progressRepository.initialize();
  await savedWordsRepository.initialize();
  await spacedRepetitionRepository.initialize();
  await authRepository.initializeGoogleSignIn();
  await authRepository.syncCurrentUser();
  await progressSyncService.pullAndMerge();

  runApp(
    FluentaApp(
      localStorage: localStorage,
      authRepository: authRepository,
      userRepository: userRepository,
      lessonContentRepository: lessonContentRepository,
      progressRepository: progressRepository,
      progressSyncService: progressSyncService,
      savedWordsRepository: savedWordsRepository,
      spacedRepetitionRepository: spacedRepetitionRepository,
      dailyVocabularyRepository: dailyVocabularyRepository,
      textToSpeechService: textToSpeechService,
      pronunciationAssessmentService: pronunciationAssessmentService,
    ),
  );
}

class FluentaApp extends StatelessWidget {
  const FluentaApp({
    super.key,
    required this.localStorage,
    required this.authRepository,
    required this.userRepository,
    required this.lessonContentRepository,
    required this.progressRepository,
    required this.progressSyncService,
    required this.savedWordsRepository,
    required this.spacedRepetitionRepository,
    required this.dailyVocabularyRepository,
    required this.textToSpeechService,
    required this.pronunciationAssessmentService,
  });

  final LocalStorage localStorage;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LessonContentRepository lessonContentRepository;
  final ProgressRepository progressRepository;
  final ProgressSyncService progressSyncService;
  final SavedWordsRepository savedWordsRepository;
  final SpacedRepetitionRepository spacedRepetitionRepository;
  final DailyVocabularyRepository dailyVocabularyRepository;
  final TextToSpeechService textToSpeechService;
  final PronunciationAssessmentService pronunciationAssessmentService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<LessonContentRepository>.value(value: lessonContentRepository),
        Provider<ProgressRepository>.value(value: progressRepository),
        Provider<ProgressSyncService>.value(value: progressSyncService),
        ChangeNotifierProvider<SavedWordsRepository>.value(
          value: savedWordsRepository,
        ),
        ChangeNotifierProvider<SpacedRepetitionRepository>.value(
          value: spacedRepetitionRepository,
        ),
        Provider<DailyVocabularyRepository>.value(
          value: dailyVocabularyRepository,
        ),
        Provider<TextToSpeechService>.value(value: textToSpeechService),
        Provider<PronunciationAssessmentService>.value(
          value: pronunciationAssessmentService,
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleViewModel(localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            authRepository,
            userRepository,
            localStorage,
            progressSyncService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageViewModel(
            localStorage,
            userRepository,
            authRepository,
            context.read<LocaleViewModel>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(localStorage),
        ),
        ChangeNotifierProvider(
          create: (context) => LearnViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<SavedWordsRepository>(),
            context.read<SpacedRepetitionRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => GrammarViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<LessonContentRepository>(),
            context.read<ProgressRepository>(),
            context.read<ProgressSyncService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReadingViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<LessonContentRepository>(),
            context.read<ProgressRepository>(),
            context.read<ProgressSyncService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => VocabularyViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<LessonContentRepository>(),
            context.read<ProgressRepository>(),
            context.read<ProgressSyncService>(),
            context.read<DailyVocabularyRepository>(),
            context.read<SpacedRepetitionRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SubscriptionViewModel(
            localStorage,
            context.read<HomeViewModel>(),
          ),
        ),
      ],
      child: Consumer<LocaleViewModel>(
        builder: (context, localeViewModel, _) {
          return MaterialApp(
            title: 'Fluenta',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: localeViewModel.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AppNavigator(
              localStorage: localStorage,
              authRepository: authRepository,
              userRepository: userRepository,
            ),
          );
        },
      ),
    );
  }
}
