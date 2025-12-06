import 'package:flutter/material.dart';

/// Custom success snackbar with animation
class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({
    super.key,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) : super(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: duration,
        );
}

