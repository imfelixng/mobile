import 'package:graphql/client.dart';

abstract class TipidApi {
  TipidApi(this.client);

  GraphQLClient client;
}
