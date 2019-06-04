import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<AuthenticationState>(
          builder: (BuildContext context) => AuthenticationState(),
        ),
      ],
      child: MaterialApp(
        title: 'Tipid',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
      ),
    );
  }
}
