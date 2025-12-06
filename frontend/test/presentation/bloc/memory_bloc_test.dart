import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pocketmind/presentation/bloc/memory/memory_bloc.dart';
import 'package:pocketmind/presentation/bloc/memory/memory_event.dart';
import 'package:pocketmind/presentation/bloc/memory/memory_state.dart';
import 'package:pocketmind/domain/usecases/get_memories_usecase.dart';
import 'package:pocketmind/domain/usecases/create_text_memory_usecase.dart';
import 'package:pocketmind/domain/usecases/upload_audio_usecase.dart';
import 'package:pocketmind/domain/usecases/search_memories_usecase.dart';
import 'package:pocketmind/domain/entities/memory_entity.dart';
import 'package:pocketmind/core/error/failures.dart';

import 'memory_bloc_test.mocks.dart';

@GenerateMocks([
  GetMemoriesUseCase,
  CreateTextMemoryUseCase,
  UploadAudioUseCase,
  SearchMemoriesUseCase,
])
void main() {
  late MemoryBloc bloc;
  late MockGetMemoriesUseCase mockGetMemoriesUseCase;
  late MockCreateTextMemoryUseCase mockCreateTextMemoryUseCase;
  late MockUploadAudioUseCase mockUploadAudioUseCase;
  late MockSearchMemoriesUseCase mockSearchMemoriesUseCase;

  final testMemory = MemoryEntity(
    id: '1',
    title: 'Test Memory',
    content: 'Test content',
    fileType: FileTypeEntity.text,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    processingStatus: ProcessingStatusEntity.completed,
    tags: [],
  );

  setUp(() {
    mockGetMemoriesUseCase = MockGetMemoriesUseCase();
    mockCreateTextMemoryUseCase = MockCreateTextMemoryUseCase();
    mockUploadAudioUseCase = MockUploadAudioUseCase();
    mockSearchMemoriesUseCase = MockSearchMemoriesUseCase();

    bloc = MemoryBloc(
      getMemoriesUseCase: mockGetMemoriesUseCase,
      createTextMemoryUseCase: mockCreateTextMemoryUseCase,
      uploadAudioUseCase: mockUploadAudioUseCase,
      searchMemoriesUseCase: mockSearchMemoriesUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be MemoryInitial', () {
    expect(bloc.state, MemoryInitial());
  });

  group('LoadMemoriesEvent', () {
    blocTest<MemoryBloc, MemoryState>(
      'emits [Loading, Loaded] when memories are fetched successfully',
      build: () {
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenAnswer((_) async => [testMemory]);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMemoriesEvent()),
      expect: () => [
        MemoryLoading(),
        MemoryLoaded([testMemory]),
      ],
      verify: (_) {
        verify(mockGetMemoriesUseCase(limit: null, offset: null)).called(1);
      },
    );

    blocTest<MemoryBloc, MemoryState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenThrow(ServerFailure('Server error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMemoriesEvent()),
      expect: () => [
        MemoryLoading(),
        MemoryError(ServerFailure('Server error')),
      ],
    );

    blocTest<MemoryBloc, MemoryState>(
      'emits [Loading, Error] when exception occurs',
      build: () {
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenThrow(Exception('Unexpected error'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMemoriesEvent()),
      expect: () => [
        MemoryLoading(),
        isA<MemoryError>(),
      ],
    );
  });

  group('CreateTextMemoryEvent', () {
    blocTest<MemoryBloc, MemoryState>(
      'emits [Uploading, Uploaded, Loading, Loaded] when memory is created successfully',
      build: () {
        when(mockCreateTextMemoryUseCase('Test content', title: null))
            .thenAnswer((_) async => testMemory);
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenAnswer((_) async => [testMemory]);
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateTextMemoryEvent(content: 'Test content')),
      expect: () => [
        MemoryUploading(),
        MemoryUploaded(testMemory),
        MemoryLoading(),
        MemoryLoaded([testMemory]),
      ],
      verify: (_) {
        verify(mockCreateTextMemoryUseCase('Test content', title: null)).called(1);
        verify(mockGetMemoriesUseCase(limit: null, offset: null)).called(1);
      },
    );

    blocTest<MemoryBloc, MemoryState>(
      'emits [Uploading, Error] when creation fails',
      build: () {
        when(mockCreateTextMemoryUseCase('Test content', title: null))
            .thenThrow(ServerFailure('Creation failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(const CreateTextMemoryEvent(content: 'Test content')),
      expect: () => [
        MemoryUploading(),
        MemoryError(ServerFailure('Creation failed')),
      ],
    );
  });

  group('UploadAudioEvent', () {
    blocTest<MemoryBloc, MemoryState>(
      'emits [Uploading, Uploaded, Loading, Loaded] when audio is uploaded successfully',
      build: () {
        when(mockUploadAudioUseCase('test_audio.m4a'))
            .thenAnswer((_) async => testMemory);
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenAnswer((_) async => [testMemory]);
        return bloc;
      },
      act: (bloc) => bloc.add(const UploadAudioEvent('test_audio.m4a')),
      expect: () => [
        MemoryUploading(),
        MemoryUploaded(testMemory),
        MemoryLoading(),
        MemoryLoaded([testMemory]),
      ],
      verify: (_) {
        verify(mockUploadAudioUseCase('test_audio.m4a')).called(1);
      },
    );
  });

  group('MemoryUpdatedEvent', () {
    blocTest<MemoryBloc, MemoryState>(
      'updates existing memory in the list',
      build: () {
        when(mockGetMemoriesUseCase(limit: null, offset: null))
            .thenAnswer((_) async => [testMemory]);
        return bloc;
      },
      seed: () => MemoryLoaded([testMemory]),
      act: (bloc) {
        final updatedMemory = testMemory.copyWith(
          title: 'Updated Title',
          summary: 'Updated summary',
        );
        bloc.add(MemoryUpdatedEvent(updatedMemory));
      },
      expect: () => [
        MemoryLoaded([
          testMemory.copyWith(
            title: 'Updated Title',
            summary: 'Updated summary',
          )
        ]),
      ],
    );
  });
}

