package com.pocketmind.application.mapper;

import com.pocketmind.application.dto.MemoryDTO;
import com.pocketmind.application.dto.TagDTO;
import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.model.Tag;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

/**
 * Mapper for converting between Domain entities and DTOs
 */
@Component
public class MemoryMapper {
    
    public MemoryDTO toDTO(Memory memory) {
        if (memory == null) {
            return null;
        }
        
        MemoryDTO dto = new MemoryDTO();
        dto.setId(memory.getId());
        dto.setTitle(memory.getTitle());
        dto.setContent(memory.getContent());
        dto.setSummary(memory.getSummary());
        dto.setFileUrl(memory.getFileUrl());
        dto.setFileType(memory.getFileType());
        dto.setCreatedAt(memory.getCreatedAt());
        dto.setUpdatedAt(memory.getUpdatedAt());
        dto.setProcessingStatus(memory.getProcessingStatus());
        dto.setEmbeddingId(memory.getEmbeddingId());
        
        if (memory.getTags() != null) {
            dto.setTags(memory.getTags().stream()
                    .map(this::tagToDTO)
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    public Memory toDomain(MemoryDTO dto) {
        if (dto == null) {
            return null;
        }
        
        Memory memory = new Memory();
        memory.setId(dto.getId());
        memory.setTitle(dto.getTitle());
        memory.setContent(dto.getContent());
        memory.setSummary(dto.getSummary());
        memory.setFileUrl(dto.getFileUrl());
        memory.setFileType(dto.getFileType());
        memory.setCreatedAt(dto.getCreatedAt());
        memory.setUpdatedAt(dto.getUpdatedAt());
        memory.setProcessingStatus(dto.getProcessingStatus());
        memory.setEmbeddingId(dto.getEmbeddingId());
        
        return memory;
    }
    
    private TagDTO tagToDTO(Tag tag) {
        if (tag == null) {
            return null;
        }
        
        TagDTO dto = new TagDTO();
        dto.setId(tag.getId());
        dto.setName(tag.getName());
        dto.setColor(tag.getColor());
        dto.setCreatedAt(tag.getCreatedAt());
        return dto;
    }
}

