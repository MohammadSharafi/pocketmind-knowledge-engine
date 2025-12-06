class AppConfig {
  // Default configuration - can be overridden via environment
  static String get graphqlEndpoint {
    const envEndpoint = String.fromEnvironment('GRAPHQL_ENDPOINT');
    return envEndpoint.isNotEmpty 
        ? envEndpoint 
        : 'http://localhost:8080/graphql';
  }

  static String get wsEndpoint {
    const envEndpoint = String.fromEnvironment('WS_ENDPOINT');
    return envEndpoint.isNotEmpty 
        ? envEndpoint 
        : 'ws://localhost:8080/graphql-ws';
  }

  static String get apiBaseUrl {
    const envUrl = String.fromEnvironment('API_BASE_URL');
    return envUrl.isNotEmpty 
        ? envUrl 
        : 'http://localhost:8080';
  }

  // For mobile devices, use these:
  // iOS Simulator: localhost
  // Android Emulator: 10.0.2.2
  // Physical Device: Your machine's IP (e.g., 192.168.1.100)
}

