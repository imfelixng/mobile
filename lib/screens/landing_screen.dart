import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  static const Key navigateToSignInButtonKey = Key('navigateToSignInButton');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Tipid',
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            RaisedButton(
              key: navigateToSignInButtonKey,
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
