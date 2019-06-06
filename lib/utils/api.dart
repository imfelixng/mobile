import 'package:graphql/client.dart';

import 'package:tipid/models/session.dart';

class TipidApi {
  TipidApi({this.client});

  GraphQLClient client;

  Future<Session> signIn(String email, String password) async {
    final QueryResult result = await client.mutate(MutationOptions(document: '''
      mutation SignIn(\$input: UserSignInInput!) {
        signIn(input: \$input) {
          authenticationToken,
          user {
            id,
            email,
            firstName,
            lastName,
            insertedAt
          }
        }
      }
      ''', variables: <String, dynamic>{
      'input': <String, String>{
        'email': email,
        'password': password,
      }
    }));

    if (result.hasErrors) {
      return Session.fromGraphQLFailure(result);
    }

    return Session.fromGraphQLSuccess(result);
  }
}
