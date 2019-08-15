import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:tipid/api/authentication_api.dart';
import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';
import 'package:tipid/screens/sign_up_screen.dart';
import 'package:tipid/widgets/main_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://localhost:4000/api',
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        cache: InMemoryCache(),
        // ignore: avoid_as
        link: httpLink as Link,
      ),
    );

    final AuthenticationApi authenticationApi = AuthenticationApi(client.value);

    return GraphQLProvider(
      client: client,
      child: MultiProvider(
        providers: <SingleChildCloneableWidget>[
          Provider<AuthenticationApi>.value(value: authenticationApi),
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
            '/': (BuildContext context) => MainView(),
            '/dashboard': (BuildContext context) => DashboardScreen(),
            '/settings': (BuildContext context) => SettingsScreen(),
            '/sign_in': (BuildContext context) => SignInScreen(),
            '/sign_up': (BuildContext context) => SignUpScreen(),
          },
        ),
      ),
    );
  }
}
