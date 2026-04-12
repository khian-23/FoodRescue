import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_rescue_network/screens/login_screen.dart';

void main() {
  testWidgets('Login screen shows expected fields and CTA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('FoodRescue Network'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have an account? Register"), findsOneWidget);
  });
}
