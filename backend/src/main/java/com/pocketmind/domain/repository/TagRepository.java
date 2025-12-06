package com.pocketmind.domain.repository;

import com.pocketmind.domain.model.Tag;

import java.util.List;
import java.util.Optional;

/**
 * Repository interface for Tag domain entity
 */
public interface TagRepository {
    List<Tag> findAll();
    Optional<Tag> findById(Long id);
    Optional<Tag> findByName(String name);
    Tag save(Tag tag);
    void deleteById(Long id);
}

