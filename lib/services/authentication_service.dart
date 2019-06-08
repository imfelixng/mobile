import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tipid/models/session.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/utils/api.dart';
import 'package:tipid/widgets/api_provider.dart';

class AuthenticationService {
  AuthenticationService({
    @required this.context,
    this.formKey,
  }) {
    authenticationState = Provider.of<AuthenticationState>(context);
    api = TipidApiProvider.of(context);
  }

  BuildContext context;
  GlobalKey<FormState> formKey;
  AuthenticationState authenticationState;
  TipidApi api;

  Future<void> signIn(TextEditingController emailController,
      TextEditingController passwordController) async {
    if (formKey.currentState.validate()) {
      authenticationState.authenticationRequest();

      final Session session =
          await api.signIn(emailController.text, passwordController.text);

      if (session.successful) {
        authenticationState.authenticationSuccess(session);
        Navigator.of(context).pop();
      } else {
        passwordController.clear();
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(session.errors[0].message),
        ));
        authenticationState.authenticationFailure();
      }
    }
  }

  Future<void> signOut() async {
    authenticationState.signOutRequest();
    authenticationState.signOutSuccess();
  }

  Future<void> signUp(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController passwordConfirmationController,
      TextEditingController firstNameController,
      TextEditingController lastNameController) async {
    if (formKey.currentState.validate()) {
      authenticationState.authenticationRequest();

      final Session session = await api.signUp(
          emailController.text,
          passwordController.text,
          passwordConfirmationController.text,
          firstNameController.text,
          lastNameController.text);

      if (session.successful) {
        authenticationState.authenticationSuccess(session);
        Navigator.of(context).pop();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(session.errors[0].message),
        ));
        authenticationState.authenticationFailure();
      }
    }
  }
}
