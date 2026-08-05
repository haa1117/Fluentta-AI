import 'package:flutter_test/flutter_test.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Home screen shows welcome text', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.getInstance();

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    expect(find.text('Welcome to Fluenta!'), findsOneWidget);
  });
}
