import 'package:firebase_core/firebase_core.dart';
import 'package:fluentta_ai/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/app_navigator.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_theme.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
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
          create: (_) => AuthViewModel(
            authRepository,
            userRepository,
            localStorage,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Fluenta',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: AppNavigator(
          localStorage: localStorage,
          authRepository: authRepository,
          userRepository: userRepository,
        ),
      ),
    );
  }
}
