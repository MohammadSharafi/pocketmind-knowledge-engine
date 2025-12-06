import 'package:flutter/material.dart';

/// Custom error snackbar with animation
class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    super.key,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) : super(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: duration,
        );
}

