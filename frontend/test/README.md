# Flutter Test Suite

This directory contains comprehensive unit tests for the PocketMind Flutter application, following Domain-Driven Design (DDD) principles.

## Test Structure

```
test/
├── domain/              # Domain layer tests
│   ├── entities/        # Entity tests
│   └── usecases/        # Use case tests
├── data/                # Data layer tests
│   ├── datasources/     # Data source tests
│   ├── repositories/    # Repository implementation tests
│   └── models/          # Model tests
├── presentation/        # Presentation layer tests
│   └── bloc/           # BLoC tests
└── core/                # Core utilities tests
    └── error/           # Error handling tests
```

## Running Tests

### Run all tests
```bash
flutter test
```

### Run tests with coverage
```bash
flutter test --coverage
```

### Run specific test file
```bash
flutter test test/domain/entities/memory_entity_test.dart
```

### Run tests in watch mode
```bash
flutter test --watch
```

## Test Coverage

The test suite covers:
- ✅ Domain entities and business logic
- ✅ Use cases and application logic
- ✅ Data sources (remote and local)
- ✅ Repository implementations
- ✅ BLoC state management
- ✅ Error handling
- ✅ Model serialization/deserialization

## Generating Mocks

When adding new mocks, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Test Best Practices

1. **Arrange-Act-Assert (AAA)**: All tests follow the AAA pattern
2. **Isolation**: Each test is independent and can run in any order
3. **Mocking**: External dependencies are mocked using Mockito
4. **Naming**: Test names clearly describe what is being tested
5. **Coverage**: Aim for >80% code coverage

## Example Test

```dart
test('should return memory when found', () async {
  // Arrange
  when(mockRepository.getMemoryById('1'))
      .thenAnswer((_) async => testMemory);

  // Act
  final result = await useCase('1');

  // Assert
  expect(result, testMemory);
  verify(mockRepository.getMemoryById('1'));
});
```

