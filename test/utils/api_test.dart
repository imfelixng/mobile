import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mockito/mockito.dart';

import 'package:tipid/models/session.dart';
import 'package:tipid/utils/api.dart';

import '../mocks.dart';

void main() {
  group('Tipid API tests', () {
    GraphQLClient mockGraphQLClient;

    setUp(() {
      mockGraphQLClient = MockGraphQLClient();
    });

    test('signIn with valid credentials returns successful Session', () async {
      final TipidApi api = TipidApi(client: mockGraphQLClient);

      final QueryResult mockResult = QueryResult(
        data: <String, dynamic>{
          'signIn': <String, dynamic>{
            'authenticationToken': 'abcd1234',
            'user': <String, String>{
              'id': '1234',
              'email': 'test@example.com',
              'firstName': 'Test',
              'lastName': 'User',
              'insertedAt': '2019-06-01T08:00:20',
            },
          },
        },
      );

      when(mockGraphQLClient.mutate(any))
          .thenAnswer((_) => Future<QueryResult>.value(mockResult));

      final Session session = await api.signIn('test@example.com', 'password');

      verify(mockGraphQLClient.mutate(any));
      expect(session.successful, true);
      expect(session.authenticationToken, 'abcd1234');
      expect(session.user.id, 1234);
      expect(session.user.email, 'test@example.com');
      expect(session.user.firstName, 'Test');
      expect(session.user.lastName, 'User');
      expect(session.user.registeredAt, DateTime.parse('2019-06-01T08:00:20'));
    });

    test('signIn with non-existing credentials returns failed Session',
        () async {
      final TipidApi api = TipidApi(client: mockGraphQLClient);

      final QueryResult mockResult = QueryResult(
        errors: <GraphQLError>[
          GraphQLError(message: 'no user with matching credentials found'),
        ],
      );

      when(mockGraphQLClient.mutate(any))
          .thenAnswer((_) => Future<QueryResult>.value(mockResult));

      final Session session = await api.signIn('test@example.com', 'password');

      verify(mockGraphQLClient.mutate(any));
      expect(session.successful, false);
      expect(
          session.errors[0].message, 'no user with matching credentials found');
    });
  });
}
