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
    result.data.forEach((dynamic key, dynamic value) {
      id = int.parse(value['user']['id']);
      email = value['user']['email'];
      firstName = value['user']['firstName'];
      lastName = value['user']['lastName'];
      registeredAt = DateTime.parse(value['user']['insertedAt']);
    });
  }

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    registeredAt = DateTime.parse(json['registeredAt']);
  }

  int id;
  String email;
  String firstName;
  String lastName;
  DateTime registeredAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id.toString(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'registeredAt': registeredAt.toString(),
    };
  }
}
