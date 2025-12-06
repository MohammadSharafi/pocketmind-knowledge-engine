import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/graphql_client.dart';
import 'bloc/memory/memory_bloc.dart';
import 'bloc/search/search_bloc.dart';
import 'services/api_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  
  runApp(const PocketMindApp());
}

class PocketMindApp extends StatelessWidget {
  const PocketMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = GraphQLService.getClient();
    final apiService = ApiService();

    return GraphQLProvider(
      client: client,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MemoryBloc(
              client: client.value,
              apiService: apiService,
            )..add(const LoadMemories()),
          ),
          BlocProvider(
            create: (context) => SearchBloc(
              client: client.value,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'PocketMind',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
