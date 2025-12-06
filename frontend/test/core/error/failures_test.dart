import 'package:flutter_test/flutter_test.dart';
import 'package:pocketmind/core/error/failures.dart';

void main() {
  group('Failure', () {
    test('ServerFailure should have message and optional code', () {
      final failure = ServerFailure('Server error', code: '500');
      
      expect(failure.message, 'Server error');
      expect(failure.code, '500');
      expect(failure.toString(), 'Server error');
    });

    test('NetworkFailure should have message', () {
      final failure = NetworkFailure('Network error');
      
      expect(failure.message, 'Network error');
      expect(failure.code, null);
    });

    test('CacheFailure should have message', () {
      final failure = CacheFailure('Cache error');
      
      expect(failure.message, 'Cache error');
    });

    test('ValidationFailure should have message', () {
      final failure = ValidationFailure('Validation error');
      
      expect(failure.message, 'Validation error');
    });

    test('NotFoundFailure should have message', () {
      final failure = NotFoundFailure('Not found');
      
      expect(failure.message, 'Not found');
    });
  });
}

