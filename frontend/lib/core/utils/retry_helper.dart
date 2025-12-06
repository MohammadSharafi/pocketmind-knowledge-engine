import 'dart:async';

/// Helper class for retry logic
class RetryHelper {
  /// Execute a function with retry logic
  static Future<T> retry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    bool Function(Object)? retryIf,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        
        // Check if we should retry
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }
        
        // If this was the last attempt, rethrow
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        // Wait before retrying (exponential backoff)
        await Future.delayed(delay * attempts);
      }
    }
    
    throw Exception('Max retries ($maxRetries) exceeded');
  }
  
  /// Retry with exponential backoff
  static Future<T> retryWithExponentialBackoff<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    return retry(
      operation: operation,
      maxRetries: maxRetries,
      delay: initialDelay,
    );
  }
}

