import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'package:tipid/state/authentication_state.dart';
import 'package:tipid/screens/dashboard_screen.dart';
import 'package:tipid/screens/landing_screen.dart';
import 'package:tipid/screens/settings_screen.dart';
import 'package:tipid/screens/sign_in_screen.dart';
import 'package:tipid/widgets/api_provider.dart';
import 'package:tipid/widgets/authenticated_view.dart';
import 'package:tipid/utils/api.dart';

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

    final TipidApi api = TipidApi(client: client.value);

    return GraphQLProvider(
      client: client,
      child: MultiProvider(
        providers: <ChangeNotifierProvider<dynamic>>[
          ChangeNotifierProvider<AuthenticationState>(
            builder: (BuildContext context) => AuthenticationState(),
          ),
        ],
        child: TipidApiProvider(
          api: api,
          child: MaterialApp(
            title: 'Tipid',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: <String, WidgetBuilder>{
              '/': (BuildContext context) {
                return Consumer<AuthenticationState>(
                  builder: (BuildContext context,
                      AuthenticationState authenticationState, Widget child) {
                    if (authenticationState.authenticated) {
                      return AuthenticatedView();
                    } else {
                      return child;
                    }
                  },
                  child: LandingScreen(),
                );
              },
              '/dashboard': (BuildContext context) => DashboardScreen(),
              '/settings': (BuildContext context) => SettingsScreen(),
              '/sign_in': (BuildContext context) => SignInScreen(),
            },
          ),
        ),
      ),
    );
  }
}
