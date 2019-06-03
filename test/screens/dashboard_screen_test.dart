import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tipid/screens/dashboard_screen.dart';

void main() {
  group('Dashboard Screen tests', () {
    Future<void> _buildDashboardScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DashboardScreen(),
      ));
    }

    testWidgets('Dashboard Screen works properly', (WidgetTester tester) async {
      await _buildDashboardScreen(tester);

      expect(find.text('Welcome to Tipid!'), findsOneWidget);
    });
  });
}
