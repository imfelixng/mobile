import 'package:graphql/client.dart';

class User {
  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.registeredAt,
  });

  User.fromGraphQL(QueryResult result) {
    id = int.parse(result.data['signIn']['user']['id']);
    email = result.data['signIn']['user']['email'];
    firstName = result.data['signIn']['user']['firstName'];
    lastName = result.data['signIn']['user']['lastName'];
    registeredAt = DateTime.parse(result.data['signIn']['user']['insertedAt']);
  }

  int id;
  String email;
  String firstName;
  String lastName;
  DateTime registeredAt;
}
