package com.pocketmind.infrastructure.persistence;

import com.pocketmind.infrastructure.persistence.entity.MemoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataMemoryRepository extends JpaRepository<MemoryEntity, Long> {
    List<MemoryEntity> findAllByOrderByCreatedAtDesc();
}

