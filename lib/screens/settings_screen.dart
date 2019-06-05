import 'package:flutter/material.dart';

import 'package:tipid/services/authentication_service.dart';

class SettingsScreen extends StatelessWidget {
  static const Key signOutButtonKey = Key('signOutButton');

  @override
  Widget build(BuildContext context) {
    final AuthenticationService authenticationService =
        AuthenticationService(context: context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: <Widget>[
            ListTile(
              key: signOutButtonKey,
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                authenticationService.signOut();
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
