import 'package:flutter/material.dart';

import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tipid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => LandingScreen(),
        '/dashboard': (BuildContext context) => DashboardScreen(),
        '/sign_in': (BuildContext context) => SignInScreen(),
      },
    );
  }
}
