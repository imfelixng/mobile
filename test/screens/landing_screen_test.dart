import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tipid/screens/landing_screen.dart';

void main() {
  testWidgets('Landing Screen works properly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LandingScreen(),
    ));

    expect(find.text('Tipid'), findsOneWidget);
  });
}
