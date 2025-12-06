import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../bloc/memory/memory_state.dart';
import '../models/memory.dart';
import 'add_memory_screen.dart';
import 'memory_detail_screen.dart';
import 'search_screen.dart';

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
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MemoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MemoryBloc>().add(const LoadMemories());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MemoryLoaded) {
            final memories = state.memories;

            if (memories.isEmpty) {
              return const Center(
                child: Text('No memories yet. Tap + to add one!'),
              );
            }

            return ListView.builder(
              itemCount: memories.length,
              itemBuilder: (context, index) {
                final memory = memories[index];
                return MemoryCard(memory: memory);
              },
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
      child: ListTile(
        title: Text(memory.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (memory.summary != null)
              Text(
                memory.summary!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(memory.processingStatus),
                const SizedBox(width: 8),
                Text(
                  _formatDate(memory.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          _getFileTypeIcon(memory.fileType),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MemoryDetailScreen(memory: memory),
            ),
          );
        },
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

