import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';
import 'package:tipid/utils/api.dart';
import 'package:tipid/widgets/api_provider.dart';

import '../mocks.dart';

void main() {
  TipidApi mockApi;

  setUp(() {
    mockApi = MockTipidApi();
  });

  group('Settings Screen tests', () {
    Future<void> _buildSettingsScreen(WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthenticationState>(
        builder: (BuildContext context) => AuthenticationState.authenticated(),
        child: TipidApiProvider(
          api: mockApi,
          child: MaterialApp(
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) {
                return Consumer<AuthenticationState>(
                  builder: (BuildContext context,
                      AuthenticationState authenticationState, Widget child) {
                    if (authenticationState.authenticated) {
                      return AuthenticatedView();
                    } else {
                      return child;
                    }
                  },
                  child: LandingScreen(),
                );
              },
            },
          ),
        ),
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

    testWidgets('Tapping Logout button signs out user',
        (WidgetTester tester) async {
      await _buildSettingsScreen(tester);

      await tester
          .tap(find.widgetWithIcon(BottomNavigationBar, Icons.settings));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(SettingsScreen.signOutButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(LandingScreen), findsOneWidget);
      expect(find.byType(AuthenticatedView), findsNothing);
    });
  });
}
