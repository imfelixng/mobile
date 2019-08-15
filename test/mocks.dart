import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:graphql/client.dart';

import 'package:tipid/api/authentication_api.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockAuthenticationApi extends Mock implements AuthenticationApi {}
