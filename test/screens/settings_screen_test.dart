import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';

void main() {
  group('Settings Screen tests', () {
    Future<void> _buildSettingsScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AuthenticatedView(),
      ));
    }

    testWidgets('Settings Screen works properly', (WidgetTester tester) async {
      await _buildSettingsScreen(tester);

      expect(find.byType(SettingsScreen), findsNothing);
      expect(find.byType(DashboardScreen), findsOneWidget);

      await tester
          .tap(find.widgetWithIcon(BottomNavigationBar, Icons.settings));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(DashboardScreen), findsNothing);
    });
  });
}
