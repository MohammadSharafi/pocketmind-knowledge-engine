/// Base failure class for error handling
abstract class Failure {
  final String message;
  final String? code;

  Failure(this.message, {this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure(String message, {String? code}) : super(message, code: code);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String message) : super(message);
}

