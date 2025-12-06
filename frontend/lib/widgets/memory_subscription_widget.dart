import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../graphql/subscriptions.dart';
import '../models/memory.dart';

/// Widget that listens to GraphQL subscriptions for memory updates
class MemorySubscriptionWidget extends StatelessWidget {
  final String memoryId;
  final Widget child;

  const MemorySubscriptionWidget({
    super.key,
    required this.memoryId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final client = GraphQLProvider.of(context).value;

    return Subscription(
      options: SubscriptionOptions(
        document: gql(GraphQLSubscriptions.memoryProcessed),
        variables: {'memoryId': memoryId},
      ),
      builder: (result) {
        if (result.hasException) {
          // Silently handle subscription errors
          return child;
        }

        if (result.isLoading) {
          return child;
        }

        if (result.data != null) {
          final memoryData = result.data!['memoryProcessed'];
          if (memoryData != null) {
            final memory = Memory.fromJson(memoryData);
            // Update the bloc with the new memory
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<MemoryBloc>().add(MemoryUpdated(memory));
            });
          }
        }

        return child;
      },
    );
  }
}

