package com.pocketmind.domain.repository;

import com.pocketmind.domain.model.Memory;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface - part of domain layer
 * Defines what operations are needed, not how they're implemented
 */
public interface MemoryRepository {
    List<Memory> findAll();
    List<Memory> findAllOrderByCreatedAtDesc();
    Optional<Memory> findById(Long id);
    Memory save(Memory memory);
    void deleteById(Long id);
    boolean existsById(Long id);
}

