import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../models/memory.dart';

class MemoryDetailScreen extends StatelessWidget {
  final Memory memory;

  const MemoryDetailScreen({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memory.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Delete Memory'),
                  content: const Text('Are you sure you want to delete this memory?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<MemoryBloc>().add(DeleteMemory(memory.id));
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusChip(memory.processingStatus),
            const SizedBox(height: 16),
            Text(
              'Created: ${_formatDate(memory.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            if (memory.summary != null) ...[
              const Text(
                'Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(memory.summary!),
              const SizedBox(height: 16),
            ],
            if (memory.content != null) ...[
              const Text(
                'Content',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(memory.content!),
              const SizedBox(height: 16),
            ],
            if (memory.tags.isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: memory.tags
                    .map((tag) => Chip(
                          label: Text(tag.name),
                          backgroundColor: tag.color != null
                              ? Color(int.parse(tag.color!.replaceFirst('#', '0xFF')))
                              : null,
                        ))
                    .toList(),
              ),
            ],
          ],
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
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

