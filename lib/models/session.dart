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

    result.data.forEach((dynamic key, dynamic value) {
      authenticationToken = value['authenticationToken'];
    });

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
