package com.pocketmind.application.usecase;

import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.model.ProcessingStatus;
import com.pocketmind.domain.repository.MemoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Use case for updating memory processing status
 */
@Service
public class UpdateMemoryStatusUseCase {
    private final MemoryRepository memoryRepository;

    public UpdateMemoryStatusUseCase(MemoryRepository memoryRepository) {
        this.memoryRepository = memoryRepository;
    }

    @Transactional
    public Memory execute(Long memoryId, ProcessingStatus status) {
        Memory memory = memoryRepository.findById(memoryId)
                .orElseThrow(() -> new IllegalArgumentException("Memory not found: " + memoryId));
        
        memory.setProcessingStatus(status);
        return memoryRepository.save(memory);
    }

    @Transactional
    public Memory markAsCompleted(Long memoryId, String content, String summary, String embeddingId) {
        Memory memory = memoryRepository.findById(memoryId)
                .orElseThrow(() -> new IllegalArgumentException("Memory not found: " + memoryId));
        
        memory.markAsCompleted(content, summary, embeddingId);
        return memoryRepository.save(memory);
    }
}

