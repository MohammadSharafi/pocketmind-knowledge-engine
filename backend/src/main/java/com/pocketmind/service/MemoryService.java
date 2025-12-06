package com.pocketmind.service;

import com.pocketmind.model.Memory;
import com.pocketmind.model.ProcessingStatus;
import com.pocketmind.model.FileType;
import com.pocketmind.model.Tag;
import com.pocketmind.queue.AITask;
import com.pocketmind.queue.TaskQueueService;
import com.pocketmind.repository.MemoryRepository;
import com.pocketmind.repository.TagRepository;
import com.pocketmind.storage.MinIOStorageService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@Slf4j
public class MemoryService {
    @Autowired
    private MemoryRepository memoryRepository;
    
    @Autowired
    private TagRepository tagRepository;
    
    @Autowired
    private MinIOStorageService storageService;
    
    @Autowired
    private TaskQueueService taskQueueService;
    
    @Value("${minio.endpoint}")
    private String minioEndpoint;
    
    @Transactional
    public Memory createMemoryFromFile(MultipartFile file, FileType fileType) {
        try {
            String fileName = storageService.uploadFile(file);
            String fileUrl = minioEndpoint + "/" + storageService.getBucketName() + "/" + fileName;
            
            Memory memory = new Memory();
            memory.setTitle(file.getOriginalFilename() != null ? 
                    file.getOriginalFilename() : "Untitled");
            memory.setFileUrl(fileUrl);
            memory.setFileType(fileType);
            memory.setProcessingStatus(ProcessingStatus.PENDING);
            
            memory = memoryRepository.save(memory);
            
            // Publish AI task
            AITask task = new AITask(memory.getId(), fileUrl, fileType.name(), fileName);
            taskQueueService.publishTask(task);
            
            return memory;
        } catch (Exception e) {
            log.error("Error creating memory from file", e);
            throw new RuntimeException("Failed to create memory", e);
        }
    }
    
    @Transactional
    public Memory createMemoryFromText(String content, String title) {
        Memory memory = new Memory();
        memory.setTitle(title != null ? title : "Text Note");
        memory.setContent(content);
        memory.setFileType(FileType.TEXT);
        memory.setProcessingStatus(ProcessingStatus.PENDING);
        
        memory = memoryRepository.save(memory);
        
        // Publish AI task for text processing
        AITask task = new AITask(memory.getId(), null, FileType.TEXT.name(), null);
        taskQueueService.publishTask(task);
        
        return memory;
    }
    
    @Transactional
    public Memory updateMemoryStatus(Long id, ProcessingStatus status) {
        Memory memory = memoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
        memory.setProcessingStatus(status);
        return memoryRepository.save(memory);
    }
    
    @Transactional
    public Memory updateMemoryContent(Long id, String content, String summary, String embeddingId) {
        Memory memory = memoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
        memory.setContent(content);
        memory.setSummary(summary);
        memory.setEmbeddingId(embeddingId);
        memory.setProcessingStatus(ProcessingStatus.COMPLETED);
        return memoryRepository.save(memory);
    }
    
    public List<Memory> getAllMemories() {
        return memoryRepository.findAllByOrderByCreatedAtDesc();
    }
    
    public Optional<Memory> getMemoryById(Long id) {
        return memoryRepository.findById(id);
    }
    
    @Transactional
    public Memory addTag(Long memoryId, Long tagId) {
        Memory memory = memoryRepository.findById(memoryId)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
        Tag tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new RuntimeException("Tag not found"));
        memory.getTags().add(tag);
        return memoryRepository.save(memory);
    }
    
    @Transactional
    public Memory removeTag(Long memoryId, Long tagId) {
        Memory memory = memoryRepository.findById(memoryId)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
        Tag tag = tagRepository.findById(tagId)
                .orElseThrow(() -> new RuntimeException("Tag not found"));
        memory.getTags().remove(tag);
        return memoryRepository.save(memory);
    }
    
    @Transactional
    public void deleteMemory(Long id) {
        Memory memory = memoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
        if (memory.getFileUrl() != null) {
            try {
                String fileName = memory.getFileUrl().substring(memory.getFileUrl().lastIndexOf("/") + 1);
                storageService.deleteFile(fileName);
            } catch (Exception e) {
                log.error("Error deleting file", e);
            }
        }
        memoryRepository.delete(memory);
    }
}

