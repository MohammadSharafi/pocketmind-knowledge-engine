import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class GraphQLService {
  static String get graphqlEndpoint => AppConfig.graphqlEndpoint;
  static String get wsEndpoint => AppConfig.wsEndpoint;

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

