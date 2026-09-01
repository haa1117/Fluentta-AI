import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Welcome text renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Welcome to Fluenta!')),
        ),
      ),
    );

    expect(find.text('Welcome to Fluenta!'), findsOneWidget);
  });
}
