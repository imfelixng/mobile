import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tipid/services/authentication_service.dart';
import 'package:tipid/state/authentication_state.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign into Tipid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SignInForm(),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  static const Key emailTextFormFieldKey = Key('emailTextFormField');
  static const Key passwordTextFormFieldKey = Key('passwordTextFormField');
  static const Key signInButtonKey = Key('signInButton');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RegExp emailRegex =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationState authenticationState =
        Provider.of<AuthenticationState>(context);

    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            key: emailTextFormFieldKey,
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email address',
            ),
            enabled: !authenticationState.loading,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter your email address';
              } else if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            key: passwordTextFormFieldKey,
            controller: passwordController,
            decoration: InputDecoration(
                labelText: 'Password', hintText: 'Enter your password'),
            enabled: !authenticationState.loading,
            obscureText: true,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              }
            },
          ),
          const SizedBox(height: 20.0),
          _signInButton(context),
        ],
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    final AuthenticationService authenticationService =
        AuthenticationService(context: context, formKey: formKey);

    return Consumer<AuthenticationState>(
      child: const Text('Login'),
      builder: (BuildContext context, AuthenticationState authenticationState,
          Widget child) {
        return RaisedButton(
          key: signInButtonKey,
          onPressed: authenticationState.loading
              ? null
              : () => authenticationService.signIn(
                  emailController, passwordController),
          child: authenticationState.loading
              ? const CircularProgressIndicator()
              : child,
        );
      },
    );
  }
}
