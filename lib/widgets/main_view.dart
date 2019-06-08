import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/services/authentication_service.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/widgets/authenticated_view.dart';

class MainView extends StatefulWidget {
  @override
  MainViewState createState() {
    return MainViewState();
  }
}

class MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () {
      final AuthenticationService authenticationService =
          AuthenticationService(context: context);
      authenticationService.checkAuthenticationStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationState>(
      builder: (BuildContext context, AuthenticationState authenticationState,
          Widget child) {
        if (authenticationState.authenticated) {
          return AuthenticatedView();
        } else {
          return child;
        }
      },
      child: LandingScreen(),
    );
  }
}
