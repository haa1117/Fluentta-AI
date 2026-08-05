import 'package:flutter/material.dart';
import 'package:fluentta_ai/app_navigator.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = await LocalStorage.getInstance();

  runApp(FluentaApp(localStorage: localStorage));
}

class FluentaApp extends StatelessWidget {
  const FluentaApp({super.key, required this.localStorage});

  final LocalStorage localStorage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluenta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AppNavigator(localStorage: localStorage),
    );
  }
}
