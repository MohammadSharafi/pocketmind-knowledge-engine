package com.pocketmind.application.usecase;

import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.model.FileType;
import com.pocketmind.domain.repository.MemoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Use case - application-specific business logic
 * Orchestrates domain objects to perform application tasks
 */
@Service
public class CreateMemoryUseCase {
    private final MemoryRepository memoryRepository;

    public CreateMemoryUseCase(MemoryRepository memoryRepository) {
        this.memoryRepository = memoryRepository;
    }

    @Transactional
    public Memory execute(String title, String content, FileType fileType) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be null or empty");
        }
        if (fileType == null) {
            throw new IllegalArgumentException("FileType cannot be null");
        }

        Memory memory = new Memory(title, fileType);
        memory.setContent(content);
        
        return memoryRepository.save(memory);
    }
}

