import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:graphql/client.dart';

import 'package:tipid/models/session.dart';
import 'package:tipid/models/user.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_up_screen.dart';
import 'package:tipid/widgets/authenticated_view.dart';
import 'package:tipid/widgets/api_provider.dart';
import 'package:tipid/utils/api.dart';

import '../mocks.dart';

void main() {
  group('Sign Up screen tests', () {
    NavigatorObserver mockObserver;
    TipidApi mockApi;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockApi = MockTipidApi();
    });

    Future<void> _buildSignUpScreen(WidgetTester tester) async {
      await tester.pumpWidget(ChangeNotifierProvider<AuthenticationState>(
        builder: (BuildContext context) => AuthenticationState(),
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
              '/sign_up': (BuildContext context) => SignUpScreen(),
            },
            navigatorObservers: <NavigatorObserver>[mockObserver],
          ),
        ),
      ));

      await tester.tap(find.byKey(LandingScreen.navigateToSignUpButtonKey));
      await tester.pumpAndSettle();
    }

    testWidgets(
        'Submitting form when entering valid data successfully authenticates the user',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.enterText(find.byKey(SignUpFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordTextFormFieldKey), 'password');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordConfirmationTextFormFieldKey),
          'password');
      await tester.enterText(
          find.byKey(SignUpFormState.firstNameTextFormFieldKey), 'Test');
      await tester.enterText(
          find.byKey(SignUpFormState.lastNameTextFormFieldKey), 'User');

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
      when(mockApi.signUp(any, any, any, any, any))
          .thenAnswer((_) => Future<Session>.value(session));

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verify(mockApi.signUp(any, any, any, any, any));
      verify(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets(
        'Submitting form when entering valid data without name successfully authenticates the user',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.enterText(find.byKey(SignUpFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordTextFormFieldKey), 'password');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordConfirmationTextFormFieldKey),
          'password');

      final Session session = Session(
        successful: true,
        authenticationToken: 'abcd1234',
        user: User(
            id: 1234,
            email: 'test@example.com',
            registeredAt: DateTime.parse('2019-06-01T08:00:20')),
      );
      when(mockApi.signUp(any, any, any, any, any))
          .thenAnswer((_) => Future<Session>.value(session));

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verify(mockApi.signUp(any, any, any, any, any));
      verify(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsOneWidget);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('Submitting form when entering existing email returns error',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.enterText(find.byKey(SignUpFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordTextFormFieldKey), 'password');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordConfirmationTextFormFieldKey),
          'password');
      await tester.enterText(
          find.byKey(SignUpFormState.firstNameTextFormFieldKey), 'Test');
      await tester.enterText(
          find.byKey(SignUpFormState.lastNameTextFormFieldKey), 'User');

      final Session session = Session(
        successful: false,
        errors: <GraphQLError>[
          GraphQLError(message: 'email has already been taken'),
        ],
      );
      when(mockApi.signUp(any, any, any, any, any))
          .thenAnswer((_) => Future<Session>.value(session));

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verify(mockApi.signUp(any, any, any, any, any));
      verifyNever(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('email has already been taken'), findsOneWidget);
    });

    testWidgets('Submitting form when entering an invalid email returns error',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.enterText(
          find.byKey(SignUpFormState.emailTextFormFieldKey), 'test@example');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordTextFormFieldKey), 'password');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordConfirmationTextFormFieldKey),
          'password');
      await tester.enterText(
          find.byKey(SignUpFormState.firstNameTextFormFieldKey), 'Test');
      await tester.enterText(
          find.byKey(SignUpFormState.lastNameTextFormFieldKey), 'User');

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verifyNever(mockApi.signUp(any, any, any, any, any));
      verifyNever(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets(
        'Submitting form when entering non-matching passwords returns error',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.enterText(find.byKey(SignUpFormState.emailTextFormFieldKey),
          'test@example.com');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordTextFormFieldKey), 'password');
      await tester.enterText(
          find.byKey(SignUpFormState.passwordConfirmationTextFormFieldKey),
          'password1');
      await tester.enterText(
          find.byKey(SignUpFormState.firstNameTextFormFieldKey), 'Test');
      await tester.enterText(
          find.byKey(SignUpFormState.lastNameTextFormFieldKey), 'User');

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verifyNever(mockApi.signUp(any, any, any, any, any));
      verifyNever(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.text('Does not match password'), findsOneWidget);
    });

    testWidgets('Submitting form without entering anything returns error',
        (WidgetTester tester) async {
      await _buildSignUpScreen(tester);

      await tester.tap(find.byKey(SignUpFormState.signUpButtonKey));
      await tester.pumpAndSettle();

      verifyNever(mockApi.signUp(any, any, any, any, any));
      verifyNever(mockObserver.didPop(any, any));
      expect(find.byType(DashboardScreen), findsNothing);
      expect(find.byType(LandingScreen), findsNothing);
      expect(find.byType(SignUpScreen), findsOneWidget);
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
    });
  });
}
