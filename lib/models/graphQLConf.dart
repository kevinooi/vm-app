import "package:flutter/material.dart";
import "package:graphql_flutter/graphql_flutter.dart";

class GraphQLConfiguration {
  static String baseURL = 'https://vm.gaincue.com';
  static HttpLink httpLink = HttpLink(

    uri: "$baseURL/graphql",
  );
  // AuthLink authLink = AuthLink(
  //   getToken: () async =>
  //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTk3NjQ5NTEyLCJleHAiOjE2MDAyNDE1MTJ9.qRwWs02P0JiYwPX33u0tHmNbCloZ6k97_zWII-4JQdc',
  // );

  static Link link = HttpLink(
    uri: "$baseURL/graphql",
  );
  ValueNotifier<GraphQLClient> _client;
  ValueNotifier<GraphQLClient> get client {
    if (link == null) {
      return null;
    }

    return _client;
  }

 set client( ValueNotifier<GraphQLClient> client) {
   _client = client;
  }

  GraphQLConfiguration() {
    // link = httpLink;
    // link = authLink.concat(httpLink);
    _client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );
  }

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      link: link,
    );
  }
  
}
