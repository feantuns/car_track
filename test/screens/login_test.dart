import 'package:car_track/main.dart';
import 'package:car_track/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:car_track/screens/login.dart';

void main() {
  group('Login Screen Widget Tests', () {
    testWidgets('Test if Login Button shows up', (WidgetTester tester) async {
      await tester.pumpWidget(CarTrack());
      expect(find.text('Entrar com o Google'), findsOneWidget);
    });
  });
}
