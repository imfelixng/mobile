import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:graphql/client.dart';

import 'package:tipid/utils/api.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockTipidApi extends Mock implements TipidApi {}
