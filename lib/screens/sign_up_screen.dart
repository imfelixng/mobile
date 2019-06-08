import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tipid/services/authentication_service.dart';
import 'package:tipid/state/authentication_state.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up for Tipid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  static const Key emailTextFormFieldKey = Key('emailTextFormField');
  static const Key passwordTextFormFieldKey = Key('passwordTextFormField');
  static const Key passwordConfirmationTextFormFieldKey =
      Key('passwordConfirmationTextFormField');
  static const Key firstNameTextFormFieldKey = Key('firstNameTextFormField');
  static const Key lastNameTextFormFieldKey = Key('lastNameTextFormField');
  static const Key signUpButtonKey = Key('signUpButton');

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final RegExp emailRegex =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
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
          TextFormField(
            key: passwordConfirmationTextFormFieldKey,
            controller: passwordConfirmationController,
            decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Enter your password again'),
            enabled: !authenticationState.loading,
            obscureText: true,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please confirm your password';
              } else if (passwordController.text != value) {
                return 'Does not match password';
              }
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            key: firstNameTextFormFieldKey,
            controller: firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              hintText: 'Enter your first name',
            ),
            enabled: !authenticationState.loading,
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            key: lastNameTextFormFieldKey,
            controller: lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              hintText: 'Enter your Last name',
            ),
            enabled: !authenticationState.loading,
          ),
          const SizedBox(height: 20.0),
          _signUpButton(context),
        ],
      ),
    );
  }

  Widget _signUpButton(BuildContext context) {
    final AuthenticationService authenticationService =
        AuthenticationService(context: context, formKey: formKey);

    return Consumer<AuthenticationState>(
      child: const Text('Register'),
      builder: (BuildContext context, AuthenticationState authenticationState,
          Widget child) {
        return RaisedButton(
          key: signUpButtonKey,
          onPressed: authenticationState.loading
              ? null
              : () => authenticationService.signUp(
                  emailController,
                  passwordController,
                  passwordConfirmationController,
                  firstNameController,
                  lastNameController),
          child: authenticationState.loading
              ? const CircularProgressIndicator()
              : child,
        );
      },
    );
  }
}
