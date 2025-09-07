// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('Renders the initial screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify that the initial screen contains the expected widgets.
    expect(find.text('Flutter Weather App'), findsOneWidget);
    expect(find.text('Select Country'), findsOneWidget);
    expect(find.text('Select City'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
