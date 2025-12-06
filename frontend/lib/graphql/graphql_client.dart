import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphQLService {
  static const String graphqlEndpoint = 'http://localhost:8080/graphql';
  static const String wsEndpoint = 'ws://localhost:8080/graphql-ws';

  static HttpLink httpLink = HttpLink(graphqlEndpoint);

  static WebSocketLink webSocketLink = WebSocketLink(
    wsEndpoint,
    config: const SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
    ),
  );

  static Link link = Link.split(
    (request) => request.isSubscription,
    webSocketLink,
    httpLink,
  );

  static ValueNotifier<GraphQLClient> getClient() {
    return ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
  }
}

