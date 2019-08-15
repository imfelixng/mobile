import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/widgets/authenticated_view.dart';
import 'package:tipid/widgets/main_view.dart';

import '../mocks.dart';

void main() {
  group('Main View tests', () {
    AuthenticationApi mockAuthenticationApi;

    setUp(() {
      mockAuthenticationApi = MockAuthenticationApi();
    });

    Future<void> _buildMainView(WidgetTester tester) async {
      await tester.pumpWidget(MultiProvider(
        providers: <SingleChildCloneableWidget>[
          Provider<AuthenticationApi>.value(value: mockAuthenticationApi),
          ChangeNotifierProvider<AuthenticationState>(
            builder: (_) => AuthenticationState(),
          ),
        ],
        child: MaterialApp(
          home: MainView(),
        ),
      ));

      await tester.pumpAndSettle();
    }

    Future<void> _setupPreferences(String key, String value) async {
      SharedPreferences.setMockInitialValues(
          <String, dynamic>{'flutter.' + key: value});
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString(key, value);
    }

    testWidgets(
        'App load when there is no stored session returns LandingScreen',
        (WidgetTester tester) async {
      await _setupPreferences('currentSession', null);
      await _buildMainView(tester);

      expect(find.byType(LandingScreen), findsOneWidget);
    });

    testWidgets(
        'App load when there is a stored session returns AuthenticatedView',
        (WidgetTester tester) async {
      const String sessionString = '''
      {
        "successful":true,
        "authenticationToken":"abcd1234",
        "user":{
          "id":"1",
          "email":"test@example.com",
          "firstName":"Test",
          "lastName":"User",
          "registeredAt":"2019-06-01 08:00:20.000"
        }
      }
      ''';
      await _setupPreferences('currentSession', sessionString);
      await _buildMainView(tester);

      expect(find.byType(AuthenticatedView), findsOneWidget);
    });
  });
}
