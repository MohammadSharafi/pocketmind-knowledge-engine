package com.pocketmind.application.usecase;

import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.repository.MemoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Use case for retrieving memories
 */
@Service
public class GetMemoriesUseCase {
    private final MemoryRepository memoryRepository;

    public GetMemoriesUseCase(MemoryRepository memoryRepository) {
        this.memoryRepository = memoryRepository;
    }

    public List<Memory> execute(Integer limit, Integer offset) {
        List<Memory> allMemories = memoryRepository.findAllOrderByCreatedAtDesc();
        
        if (offset == null) offset = 0;
        if (limit == null) limit = allMemories.size();
        
        int start = Math.max(0, offset);
        int end = Math.min(start + limit, allMemories.size());
        
        if (start >= allMemories.size()) {
            return List.of();
        }
        
        return allMemories.subList(start, end);
    }
}

