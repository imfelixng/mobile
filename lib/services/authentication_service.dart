import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:tipid/state/authentication_state.dart';

class AuthenticationService {
  AuthenticationService({
    @required this.context,
    this.formKey,
  }) {
    authenticationState = Provider.of<AuthenticationState>(context);
  }

  BuildContext context;
  GlobalKey<FormState> formKey;
  AuthenticationState authenticationState;

  Future<void> signIn(String email, String password) async {
    if (formKey.currentState.validate()) {
      authenticationState.authenticationRequest();
      authenticationState.authenticationSuccess();
      Navigator.of(context).pop();
    }
  }

  Future<void> signOut() async {
    authenticationState.signOutRequest();
    authenticationState.signOutSuccess();
  }
}
