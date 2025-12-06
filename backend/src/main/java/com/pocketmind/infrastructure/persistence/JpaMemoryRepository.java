package com.pocketmind.infrastructure.persistence;

import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.repository.MemoryRepository;
import com.pocketmind.infrastructure.persistence.entity.MemoryEntity;
import com.pocketmind.infrastructure.persistence.mapper.MemoryEntityMapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Infrastructure layer - JPA implementation of domain repository
 * Bridges domain and infrastructure layers
 */
@Repository
public class JpaMemoryRepository implements MemoryRepository {
    private final SpringDataMemoryRepository springDataRepository;
    private final MemoryEntityMapper mapper;

    public JpaMemoryRepository(
            SpringDataMemoryRepository springDataRepository,
            MemoryEntityMapper mapper) {
        this.springDataRepository = springDataRepository;
        this.mapper = mapper;
    }

    @Override
    public List<Memory> findAll() {
        return springDataRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Memory> findAllOrderByCreatedAtDesc() {
        return springDataRepository.findAllByOrderByCreatedAtDesc().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Memory> findById(Long id) {
        return springDataRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Memory save(Memory memory) {
        MemoryEntity entity = mapper.toEntity(memory);
        MemoryEntity saved = springDataRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(Long id) {
        springDataRepository.deleteById(id);
    }

    @Override
    public boolean existsById(Long id) {
        return springDataRepository.existsById(id);
    }
}

