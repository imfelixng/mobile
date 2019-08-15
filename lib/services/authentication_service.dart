import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/models/session.dart';
import 'package:tipid/state/authentication_state.dart';

class AuthenticationService {
  AuthenticationService({
    @required this.context,
  }) {
    authenticationState = Provider.of<AuthenticationState>(context);
    api = Provider.of<AuthenticationApi>(context);
  }

  BuildContext context;
  AuthenticationState authenticationState;
  AuthenticationApi api;

  Future<void> checkAuthenticationStatus() async {
    authenticationState.authenticationRequest();

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String currentSession = preferences.getString('currentSession');

    if (currentSession == null || currentSession == '') {
      authenticationState.authenticationFailure();
    } else {
      final Session session = Session.fromJson(json.decode(currentSession));
      authenticationState.authenticationSuccess(session);
    }
  }

  Future<void> signIn(TextEditingController emailController,
      TextEditingController passwordController) async {
    authenticationState.authenticationRequest();

    final Session session =
        await api.signIn(emailController.text, passwordController.text);

    if (session.successful) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString('currentSession', session.toString());
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

  Future<void> signOut() async {
    authenticationState.signOutRequest();

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('currentSession');

    authenticationState.signOutSuccess();
  }

  Future<void> signUp(
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController passwordConfirmationController,
      TextEditingController firstNameController,
      TextEditingController lastNameController) async {
    authenticationState.authenticationRequest();

    final Session session = await api.signUp(
        emailController.text,
        passwordController.text,
        passwordConfirmationController.text,
        firstNameController.text,
        lastNameController.text);

    if (session.successful) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      await preferences.setString('currentSession', session.toString());
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
