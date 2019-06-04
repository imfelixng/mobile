import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';

import '../mocks.dart';

void main() {
  group('Sign In Screen tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildSignInScreen(WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthenticationState>(
        builder: (BuildContext context) => AuthenticationState(),
        child: MaterialApp(
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (BuildContext context) {
              return Consumer<AuthenticationState>(
                builder: (BuildContext context,
                    AuthenticationState authenticationState, Widget child) {
                  if (authenticationState.authenticated) {
                    return DashboardScreen();
                  } else {
                    return child;
                  }
                },
                child: LandingScreen(),
              );
            },
            '/dashboard': (BuildContext context) => DashboardScreen(),
            '/sign_in': (BuildContext context) => SignInScreen(),
          },
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      ));

      await tester.tap(find.byKey(LandingScreen.navigateToSignInButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets('Submitting form while entering valid data returns success',
        (WidgetTester tester) async {
      await _buildSignInScreen(tester);

      await tester.enterText(find.byKey(SignInFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignInFormState.passwordTextFormFieldKey), 'password');
      await tester.tap(find.byKey(SignInFormState.signInButtonKey));
      await tester.pumpAndSettle();

      verify(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets(
        'Submitting form while entering an invalid email address returns error',
        (WidgetTester tester) async {
      await _buildSignInScreen(tester);

      await tester.enterText(
          find.byKey(SignInFormState.emailTextFormFieldKey), 'test@example');
      await tester.enterText(
          find.byKey(SignInFormState.passwordTextFormFieldKey), 'password');
      await tester.tap(find.byKey(SignInFormState.signInButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsNothing);
    });

    testWidgets('Submitting form without entering anything returns error',
        (WidgetTester tester) async {
      await _buildSignInScreen(tester);

      await tester.tap(find.byKey(SignInFormState.signInButtonKey));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });
}
