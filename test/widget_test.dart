// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bank_app/pages/home_page.dart';
import 'package:bank_app/pages/sign_in/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bank_app/main.dart';

void main() {
  Widget testWidget = const MediaQuery(data: MediaQueryData(), child: MaterialApp(
      home: MyApp()
  ));
  testWidgets("Auth type changes when tapping Don't have an account", (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);



    expect(find.text("Don\'t have an account?"), findsOneWidget);
    expect(find.text("Already have an account?"), findsNothing);

    final Finder button = find.byKey(const Key("switchButton"));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text("Don't have an account?"), findsNothing);
    expect(find.text("Already have an account?"), findsOneWidget);
  });
}
