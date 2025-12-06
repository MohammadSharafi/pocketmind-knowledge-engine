# Testing Guide

This document provides comprehensive information about testing in the PocketMind Flutter application.

## Test Structure

The test suite follows Domain-Driven Design (DDD) principles and is organized into three main layers:

### Domain Layer Tests
- **Entities**: Test business logic and domain rules
- **Use Cases**: Test application-specific business logic

### Data Layer Tests
- **Data Sources**: Test remote and local data access
- **Repositories**: Test repository implementations
- **Models**: Test data serialization/deserialization

### Presentation Layer Tests
- **BLoC**: Test state management and business logic flow

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run with Coverage
```bash
flutter test --coverage
```

### Generate HTML Coverage Report
```bash
./.test_coverage.sh
```

### Run Specific Test File
```bash
flutter test test/domain/entities/memory_entity_test.dart
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

## Test Coverage Goals

- **Domain Layer**: 100% coverage (pure business logic)
- **Data Layer**: >90% coverage (critical data operations)
- **Presentation Layer**: >80% coverage (UI logic)

## Generating Mocks

When you add new interfaces or abstract classes that need mocking:

1. Add `@GenerateMocks([YourClass])` annotation
2. Import the generated mocks file
3. Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Writing Tests

### Test Structure (AAA Pattern)

```dart
test('should do something when condition is met', () {
  // Arrange - Set up test data and mocks
  final testData = TestData();
  when(mockRepository.getData()).thenAnswer((_) async => testData);

  // Act - Execute the code under test
  final result = await useCase();

  // Assert - Verify the results
  expect(result, testData);
  verify(mockRepository.getData()).called(1);
});
```

### BLoC Testing

```dart
blocTest<MemoryBloc, MemoryState>(
  'emits [Loading, Loaded] when data is fetched',
  build: () {
    when(mockUseCase()).thenAnswer((_) async => testData);
    return bloc;
  },
  act: (bloc) => bloc.add(LoadEvent()),
  expect: () => [
    LoadingState(),
    LoadedState(testData),
  ],
);
```

## Best Practices

1. **Isolation**: Each test should be independent
2. **Naming**: Use descriptive test names that explain what is being tested
3. **Mocking**: Mock external dependencies (network, file system, etc.)
4. **Coverage**: Aim for high coverage but focus on critical paths
5. **Speed**: Keep tests fast (< 1 second per test when possible)

## Common Test Patterns

### Testing Use Cases
- Test successful execution
- Test validation errors
- Test error propagation

### Testing Data Sources
- Test successful API calls
- Test error handling
- Test data transformation

### Testing BLoCs
- Test state transitions
- Test event handling
- Test error states

## Continuous Integration

Tests run automatically on:
- Pull requests
- Commits to main branch
- Manual workflow triggers

See `.github/workflows/flutter_test.yml` for CI configuration.

