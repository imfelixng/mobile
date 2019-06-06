import 'package:graphql/client.dart';

import 'package:tipid/models/user.dart';

class Session {
  Session({
    this.successful,
    this.errors,
    this.authenticationToken,
    this.user,
  });

  Session.fromGraphQLSuccess(QueryResult result) {
    successful = true;
    authenticationToken = result.data['signIn']['authenticationToken'];
    user = User.fromGraphQL(result);
  }

  Session.fromGraphQLFailure(QueryResult result) {
    successful = false;
    errors = result.errors;
  }

  bool successful;
  List<GraphQLError> errors;
  String authenticationToken;
  User user;
}
