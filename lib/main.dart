import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/app_navigator.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/navigation/password_reset_deep_link_handler.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_theme.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_sync_repository.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/english_basics_repository.dart';
import 'package:fluentta_ai/data/repositories/daily_vocabulary_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_sync_repository.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/repositories/spaced_repetition_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/data/services/iap_service.dart';
import 'package:fluentta_ai/data/services/local_notification_service.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_view_model.dart';
import 'package:fluentta_ai/viewmodels/grammar_view_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/learn_view_model.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/viewmodels/subscription_view_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_view_model.dart';
import 'package:fluentta_ai/core/navigation/root_navigator_key.dart';
import 'package:fluentta_ai/widgets/auth/password_reset_link_listener.dart';
import 'package:fluentta_ai/widgets/common/notification_lifecycle_watcher.dart';
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
  final dailyLessonRepository = DailyLessonRepository(localStorage);
  final englishBasicsRepository = EnglishBasicsRepository(
    localStorage,
    progressRepository,
    dailyLessonRepository,
  );
  final roleplayContentSyncRepository = RoleplayContentSyncRepository();
  final roleplayContentRepository = RoleplayContentRepository(
    localStorage,
    roleplayContentSyncRepository,
  );
  final learningStatsService = LearningStatsService(
    localStorage,
    progressRepository,
  );
  final entitlementsService = EntitlementsService(localStorage);
  final progressSyncService = ProgressSyncService(
    progressRepository: progressRepository,
    syncRepository: progressSyncRepository,
    userRepository: userRepository,
    localStorage: localStorage,
    learningStatsService: learningStatsService,
    entitlementsService: entitlementsService,
  );
  final textToSpeechService = TextToSpeechService();
  final pronunciationAssessmentService = PronunciationAssessmentService();
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  if (!kIsWeb) {
    final openedFromResetLink =
        await _handleLaunchPasswordResetLink(authRepository);
    if (!openedFromResetLink) {
      await authRepository.discardPersistedPasswordResetLaunch();
    }
  }

  final isPasswordResetLaunch =
      authRepository.shouldLaunchDirectToPasswordReset;

  if (isPasswordResetLaunch) {
    await authRepository.initializeGoogleSignIn();
  } else {
    await lessonContentRepository.initialize();
    await progressRepository.initialize();
    await progressSyncService.ensureLessonXpBackfill();
    await savedWordsRepository.initialize();
    await spacedRepetitionRepository.initialize();
    await roleplayContentRepository.initialize();
    await authRepository.initializeGoogleSignIn();
    await authRepository.syncCurrentUser();
    await entitlementsService.ensureDailyHeartsReset();
    await progressSyncService.pullAndMerge();
  }

  runApp(
    FluentaApp(
      localStorage: localStorage,
      authRepository: authRepository,
      userRepository: userRepository,
      lessonContentRepository: lessonContentRepository,
      progressRepository: progressRepository,
      progressSyncService: progressSyncService,
      learningStatsService: learningStatsService,
      entitlementsService: entitlementsService,
      savedWordsRepository: savedWordsRepository,
      spacedRepetitionRepository: spacedRepetitionRepository,
      dailyVocabularyRepository: dailyVocabularyRepository,
      dailyLessonRepository: dailyLessonRepository,
      englishBasicsRepository: englishBasicsRepository,
      roleplayContentRepository: roleplayContentRepository,
      textToSpeechService: textToSpeechService,
      pronunciationAssessmentService: pronunciationAssessmentService,
      localNotificationService: localNotificationService,
    ),
  );
}

Future<bool> _handleLaunchPasswordResetLink(
  AuthRepository authRepository,
) async {
  try {
    final initialUri = await AppLinks().getInitialLink();
    if (initialUri == null) return false;

    if (kDebugMode) {
      debugPrint('Launch password reset link: $initialUri');
    }

    return PasswordResetDeepLinkHandler.handleUri(initialUri, authRepository);
  } catch (error) {
    if (kDebugMode) {
      debugPrint('Launch password reset link failed: $error');
    }
    return false;
  }
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
    required this.learningStatsService,
    required this.entitlementsService,
    required this.savedWordsRepository,
    required this.spacedRepetitionRepository,
    required this.dailyVocabularyRepository,
    required this.dailyLessonRepository,
    required this.englishBasicsRepository,
    required this.roleplayContentRepository,
    required this.textToSpeechService,
    required this.pronunciationAssessmentService,
    required this.localNotificationService,
  });

  final LocalStorage localStorage;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LessonContentRepository lessonContentRepository;
  final ProgressRepository progressRepository;
  final ProgressSyncService progressSyncService;
  final LearningStatsService learningStatsService;
  final EntitlementsService entitlementsService;
  final SavedWordsRepository savedWordsRepository;
  final SpacedRepetitionRepository spacedRepetitionRepository;
  final DailyVocabularyRepository dailyVocabularyRepository;
  final DailyLessonRepository dailyLessonRepository;
  final EnglishBasicsRepository englishBasicsRepository;
  final RoleplayContentRepository roleplayContentRepository;
  final TextToSpeechService textToSpeechService;
  final PronunciationAssessmentService pronunciationAssessmentService;
  final LocalNotificationService localNotificationService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<LocalNotificationService>.value(
          value: localNotificationService,
        ),
        Provider<LessonContentRepository>.value(value: lessonContentRepository),
        Provider<ProgressRepository>.value(value: progressRepository),
        Provider<ProgressSyncService>.value(value: progressSyncService),
        Provider<LearningStatsService>.value(value: learningStatsService),
        Provider<EntitlementsService>.value(value: entitlementsService),
        ChangeNotifierProvider<SavedWordsRepository>.value(
          value: savedWordsRepository,
        ),
        ChangeNotifierProvider<SpacedRepetitionRepository>.value(
          value: spacedRepetitionRepository,
        ),
        Provider<DailyVocabularyRepository>.value(
          value: dailyVocabularyRepository,
        ),
        Provider<DailyLessonRepository>.value(
          value: dailyLessonRepository,
        ),
        Provider<EnglishBasicsRepository>.value(
          value: englishBasicsRepository,
        ),
        Provider<RoleplayContentRepository>.value(
          value: roleplayContentRepository,
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
          create: (context) => HomeViewModel(
            localStorage,
            context.read<ProgressSyncService>(),
            context.read<EntitlementsService>(),
          ),
        ),
        Provider<IapService>(
          create: (context) => IapService(
            localStorage,
            context.read<HomeViewModel>(),
          ),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider(
          create: (context) => SubscriptionViewModel(
            localStorage,
            context.read<HomeViewModel>(),
            context.read<IapService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EnglishBasicsViewModel(
            localStorage,
            context.read<EnglishBasicsRepository>(),
          ),
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
            context.read<DailyLessonRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReadingViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<LessonContentRepository>(),
            context.read<ProgressRepository>(),
            context.read<ProgressSyncService>(),
            context.read<DailyLessonRepository>(),
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
            context.read<DailyLessonRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(
            localStorage,
            context.read<LocaleViewModel>(),
            context.read<LocalNotificationService>(),
            context.read<LearningStatsService>(),
            context.read<ProgressSyncService>(),
            context.read<EntitlementsService>(),
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
            navigatorKey: rootNavigatorKey,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: PasswordResetLinkListener(
              child: NotificationLifecycleWatcher(
                child: AppNavigator(
                  localStorage: localStorage,
                  authRepository: authRepository,
                  userRepository: userRepository,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
