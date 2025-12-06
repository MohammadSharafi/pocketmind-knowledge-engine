import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../bloc/memory/memory_state.dart';
import '../models/memory.dart';
import 'add_memory_screen.dart';
import 'memory_detail_screen.dart';
import 'search_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/subscriptions.dart';
import '../presentation/widgets/loading_shimmer.dart';
import '../core/error/error_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketMind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<MemoryBloc, MemoryState>(
        builder: (context, state) {
          if (state is MemoryLoading) {
            return const LoadingShimmer();
          }

          if (state is MemoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ErrorHandler.getUserFriendlyMessage(state.failure),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<MemoryBloc>().add(const LoadMemories());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is MemoryLoaded) {
            final memories = state.memories;

            if (memories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No memories yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first memory',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MemoryBloc>().add(const LoadMemories());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  final memory = memories[index];
                  return MemoryCard(memory: memory);
                },
              ),
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMemoryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final Memory memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MemoryDetailScreen(memory: memory),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      memory.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Icon(
                    _getFileTypeIcon(memory.fileType),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              if (memory.summary != null) ...[
                const SizedBox(height: 8),
                Text(
                  memory.summary!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusChip(memory.processingStatus),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(memory.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  if (memory.tags.isNotEmpty) ...[
                    const Spacer(),
                    Wrap(
                      spacing: 4,
                      children: memory.tags.take(3).map((tag) {
                        return Chip(
                          label: Text(
                            tag.name,
                            style: const TextStyle(fontSize: 10),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ProcessingStatus status) {
    Color color;
    String label;

    switch (status) {
      case ProcessingStatus.pending:
        color = Colors.grey;
        label = 'Pending';
        break;
      case ProcessingStatus.processing:
        color = Colors.blue;
        label = 'Processing';
        break;
      case ProcessingStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case ProcessingStatus.failed:
        color = Colors.red;
        label = 'Failed';
        break;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  IconData _getFileTypeIcon(FileType type) {
    switch (type) {
      case FileType.audio:
        return Icons.audiotrack;
      case FileType.image:
        return Icons.image;
      case FileType.text:
        return Icons.text_fields;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

