import 'failures.dart';

/// Error handler for user-friendly error messages
class ErrorHandler {
  /// Get user-friendly error message from failure
  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network and try again.';
    }
    
    if (failure is ServerFailure) {
      if (failure.code == '500') {
        return 'Server error. Please try again later.';
      }
      if (failure.code == '404') {
        return 'The requested resource was not found.';
      }
      if (failure.code == '403') {
        return 'You don\'t have permission to perform this action.';
      }
      return failure.message.isNotEmpty 
          ? failure.message 
          : 'Server error. Please try again later.';
    }
    
    if (failure is NotFoundFailure) {
      return 'Memory not found. It may have been deleted.';
    }
    
    if (failure is ValidationFailure) {
      return failure.message.isNotEmpty 
          ? failure.message 
          : 'Invalid input. Please check your data and try again.';
    }
    
    if (failure is CacheFailure) {
      return 'Failed to save data locally. Please try again.';
    }
    
    // Generic fallback
    return 'Something went wrong. Please try again.';
  }
  
  /// Get error title for display
  static String getErrorTitle(Failure failure) {
    if (failure is NetworkFailure) {
      return 'Connection Error';
    }
    if (failure is ServerFailure) {
      return 'Server Error';
    }
    if (failure is NotFoundFailure) {
      return 'Not Found';
    }
    if (failure is ValidationFailure) {
      return 'Validation Error';
    }
    return 'Error';
  }
  
  /// Check if error is retryable
  static bool isRetryable(Failure failure) {
    return failure is NetworkFailure || 
           (failure is ServerFailure && failure.code != '400' && failure.code != '404');
  }
}

