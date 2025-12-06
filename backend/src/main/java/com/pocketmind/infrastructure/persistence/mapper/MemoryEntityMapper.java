package com.pocketmind.infrastructure.persistence.mapper;

import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.model.Tag;
import com.pocketmind.infrastructure.persistence.entity.MemoryEntity;
import com.pocketmind.infrastructure.persistence.entity.TagEntity;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

/**
 * Mapper between Domain entities and JPA entities
 */
@Component
public class MemoryEntityMapper {
    
    public Memory toDomain(MemoryEntity entity) {
        if (entity == null) {
            return null;
        }
        
        Memory memory = new Memory();
        memory.setId(entity.getId());
        memory.setTitle(entity.getTitle());
        memory.setContent(entity.getContent());
        memory.setSummary(entity.getSummary());
        memory.setFileUrl(entity.getFileUrl());
        memory.setFileType(entity.getFileType());
        memory.setCreatedAt(entity.getCreatedAt());
        memory.setUpdatedAt(entity.getUpdatedAt());
        memory.setProcessingStatus(entity.getProcessingStatus());
        memory.setEmbeddingId(entity.getEmbeddingId());
        
        if (entity.getTags() != null) {
            Set<Tag> tags = entity.getTags().stream()
                    .map(this::tagEntityToDomain)
                    .collect(Collectors.toSet());
            memory.setTags(tags);
        }
        
        return memory;
    }
    
    public MemoryEntity toEntity(Memory memory) {
        if (memory == null) {
            return null;
        }
        
        MemoryEntity entity = new MemoryEntity();
        entity.setId(memory.getId());
        entity.setTitle(memory.getTitle());
        entity.setContent(memory.getContent());
        entity.setSummary(memory.getSummary());
        entity.setFileUrl(memory.getFileUrl());
        entity.setFileType(memory.getFileType());
        entity.setCreatedAt(memory.getCreatedAt());
        entity.setUpdatedAt(memory.getUpdatedAt());
        entity.setProcessingStatus(memory.getProcessingStatus());
        entity.setEmbeddingId(memory.getEmbeddingId());
        
        if (memory.getTags() != null) {
            Set<TagEntity> tagEntities = memory.getTags().stream()
                    .map(this::tagDomainToEntity)
                    .collect(Collectors.toSet());
            entity.setTags(tagEntities);
        }
        
        return entity;
    }
    
    private Tag tagEntityToDomain(TagEntity entity) {
        Tag tag = new Tag();
        tag.setId(entity.getId());
        tag.setName(entity.getName());
        tag.setColor(entity.getColor());
        tag.setCreatedAt(entity.getCreatedAt());
        return tag;
    }
    
    private TagEntity tagDomainToEntity(Tag tag) {
        TagEntity entity = new TagEntity();
        entity.setId(tag.getId());
        entity.setName(tag.getName());
        entity.setColor(tag.getColor());
        entity.setCreatedAt(tag.getCreatedAt());
        return entity;
    }
}

