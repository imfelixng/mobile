import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';

import '../mocks.dart';

void main() {
  group('Landing Screen tests', () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _buildLandingScreen(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: LandingScreen(),
        routes: <String, WidgetBuilder>{
          '/sign_in': (BuildContext context) => SignInScreen(),
        },
        navigatorObservers: <NavigatorObserver>[mockObserver],
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
