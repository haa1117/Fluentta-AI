import 'package:firebase_core/firebase_core.dart';

import 'package:fluentta_ai/firebase_options.dart';

import 'package:flutter/material.dart';

import 'package:fluentta_ai/app_navigator.dart';

import 'package:fluentta_ai/core/l10n/locale_view_model.dart';

import 'package:fluentta_ai/core/storage/local_storage.dart';

import 'package:fluentta_ai/core/theme/app_theme.dart';

import 'package:fluentta_ai/data/repositories/auth_repository.dart';

import 'package:fluentta_ai/data/repositories/user_repository.dart';

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



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );



  final localStorage = await LocalStorage.getInstance();

  final userRepository = UserRepository(localStorage);

  final authRepository = AuthRepository(localStorage, userRepository);

  await authRepository.initializeGoogleSignIn();

  await authRepository.syncCurrentUser();



  runApp(FluentaApp(

    localStorage: localStorage,

    authRepository: authRepository,

    userRepository: userRepository,

  ));

}



class FluentaApp extends StatelessWidget {

  const FluentaApp({

    super.key,

    required this.localStorage,

    required this.authRepository,

    required this.userRepository,

  });



  final LocalStorage localStorage;

  final AuthRepository authRepository;

  final UserRepository userRepository;



  @override

  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        Provider<UserRepository>.value(value: userRepository),

        Provider<AuthRepository>.value(value: authRepository),

        ChangeNotifierProvider(

          create: (_) => LocaleViewModel(localStorage),

        ),

        ChangeNotifierProvider(

          create: (_) => AuthViewModel(

            authRepository,

            userRepository,

            localStorage,

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

          ),

        ),

        ChangeNotifierProvider(

          create: (context) => GrammarViewModel(

            localStorage,

            context.read<LocaleViewModel>(),

          ),

        ),

        ChangeNotifierProvider(

          create: (context) => ReadingViewModel(

            localStorage,

            context.read<LocaleViewModel>(),

          ),

        ),

        ChangeNotifierProvider(

          create: (context) => VocabularyViewModel(

            localStorage,

            context.read<LocaleViewModel>(),

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


