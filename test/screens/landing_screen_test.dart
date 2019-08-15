import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';

import '../mocks.dart';

void main() {
  group('Landing Screen tests', () {
    NavigatorObserver mockObserver;
    AuthenticationApi mockAuthenticationApi;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAuthenticationApi = MockAuthenticationApi();
    });

    Future<void> _buildLandingScreen(WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: <SingleChildCloneableWidget>[
          Provider<AuthenticationApi>.value(value: mockAuthenticationApi),
          ChangeNotifierProvider<AuthenticationState>(
            builder: (_) => AuthenticationState(),
          ),
        ],
        child: MaterialApp(
          home: LandingScreen(),
          routes: <String, WidgetBuilder>{
            '/sign_in': (BuildContext context) => SignInScreen(),
          },
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      ));
    }

    testWidgets('Landing Screen works properly', (WidgetTester tester) async {
      await _buildLandingScreen(tester);

      expect(find.text('Tipid'), findsOneWidget);
    });

    testWidgets('Tapping Login button navigates to Sign In screen',
        (WidgetTester tester) async {
      await _buildLandingScreen(tester);

      await tester.tap(find.byKey(LandingScreen.navigateToSignInButtonKey));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(SignInScreen), findsOneWidget);
    });
  });
}
