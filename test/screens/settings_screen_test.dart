import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';

import '../mocks.dart';

void main() {
  AuthenticationApi mockAuthenticationApi;

  setUp(() {
    mockAuthenticationApi = MockAuthenticationApi();
    SharedPreferences.setMockInitialValues(<String, dynamic>{});
  });

  group('Settings Screen tests', () {
    Future<void> _buildSettingsScreen(WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: <SingleChildCloneableWidget>[
          Provider<AuthenticationApi>.value(value: mockAuthenticationApi),
          ChangeNotifierProvider<AuthenticationState>(
            builder: (_) => AuthenticationState.authenticated(),
          ),
        ],
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
