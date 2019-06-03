import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tipid/screens/sign_in_screen.dart';

void main() {
  group('Sign In Screen tests', () {
    Future<void> _buildSignInScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SignInScreen(),
      ));
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

      expect(find.text('Please enter your email address'), findsNothing);
      expect(find.text('Please enter your password'), findsNothing);
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
