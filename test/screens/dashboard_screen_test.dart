import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';

void main() {
  group('Dashboard Screen tests', () {
    Future<void> _buildDashboardScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AuthenticatedView(),
      ));
    }

    testWidgets('Dashboard Screen works properly', (WidgetTester tester) async {
      await _buildDashboardScreen(tester);

      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });
}
