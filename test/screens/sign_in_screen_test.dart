import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/models/session.dart';
import 'package:tipid/models/user.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';

import '../mocks.dart';

void main() {
  group('Sign In Screen tests', () {
    NavigatorObserver mockObserver;
    AuthenticationApi mockAuthenticationApi;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAuthenticationApi = MockAuthenticationApi();
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
    });

    Future<void> _buildSignInScreen(WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: <SingleChildCloneableWidget>[
          Provider<AuthenticationApi>.value(value: mockAuthenticationApi),
          ChangeNotifierProvider<AuthenticationState>(
            builder: (_) => AuthenticationState(),
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
            '/sign_in': (BuildContext context) => SignInScreen(),
          },
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      ));

      await tester.tap(find.byKey(LandingScreen.navigateToSignInButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets(
        'Submitting form when entering valid data successfully authenticates the user',
        (WidgetTester tester) async {
      await _buildSignInScreen(tester);

      await tester.enterText(find.byKey(SignInFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignInFormState.passwordTextFormFieldKey), 'password');

      final Session session = Session(
        successful: true,
        authenticationToken: 'abcd1234',
        user: User(
            id: 1234,
            email: 'test@example.com',
            firstName: 'Test',
            lastName: 'User',
            registeredAt: DateTime.parse('2019-06-01T08:00:20')),
      );
      when(mockAuthenticationApi.signIn(any, any))
          .thenAnswer((_) => Future<Session>.value(session));

      await tester.tap(find.byKey(SignInFormState.signInButtonKey));
      await tester.pumpAndSettle();

      verify(mockAuthenticationApi.signIn(any, any));
      verify(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets('Submitting form when user has not registered returns error',
        (WidgetTester tester) async {
      await _buildSignInScreen(tester);

      await tester.enterText(find.byKey(SignInFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignInFormState.passwordTextFormFieldKey), 'password');

      final Session session = Session(
        successful: false,
        errors: <GraphQLError>[
          GraphQLError(message: 'no user with matching credentials found'),
        ],
      );
      when(mockAuthenticationApi.signIn(any, any))
          .thenAnswer((_) => Future<Session>.value(session));

      await tester.tap(find.byKey(SignInFormState.signInButtonKey));
      await tester.pumpAndSettle();

      verify(mockAuthenticationApi.signIn(any, any));
      verifyNever(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.text('no user with matching credentials found'), findsOneWidget);
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
