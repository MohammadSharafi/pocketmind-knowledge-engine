import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/memory_entity.dart';

/// Animated memory card with smooth transitions and interactions
class AnimatedMemoryCard extends StatefulWidget {
  final MemoryEntity memory;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const AnimatedMemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<AnimatedMemoryCard> createState() => _AnimatedMemoryCardState();
}

class _AnimatedMemoryCardState extends State<AnimatedMemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: _isPressed ? 2 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          borderRadius: BorderRadius.circular(16),
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.memory.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildFileTypeIcon(context),
            ],
          ),
          if (widget.memory.summary != null) ...[
            const SizedBox(height: 12),
            Text(
              widget.memory.summary!,
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
              _buildStatusChip(widget.memory.processingStatus),
              const SizedBox(width: 8),
              Text(
                _formatDate(widget.memory.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              if (widget.memory.tags.isNotEmpty) ...[
                const Spacer(),
                _buildTags(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileTypeIcon(BuildContext context) {
    IconData icon;
    Color color;

    switch (widget.memory.fileType) {
      case FileTypeEntity.audio:
        icon = Icons.audiotrack;
        color = Colors.purple;
        break;
      case FileTypeEntity.image:
        icon = Icons.image;
        color = Colors.blue;
        break;
      case FileTypeEntity.text:
        icon = Icons.text_fields;
        color = Colors.green;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusChip(ProcessingStatusEntity status) {
    Color color;
    IconData icon;

    switch (status) {
      case ProcessingStatusEntity.pending:
        color = Colors.grey;
        icon = Icons.schedule;
        break;
      case ProcessingStatusEntity.processing:
        color = Colors.blue;
        icon = Icons.sync;
        break;
      case ProcessingStatusEntity.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case ProcessingStatusEntity.failed:
        color = Colors.red;
        icon = Icons.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: widget.memory.tags.take(2).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag.name,
            style: const TextStyle(fontSize: 10),
          ),
        );
      }).toList(),
    );
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

