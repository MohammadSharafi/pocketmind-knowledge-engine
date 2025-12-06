package com.pocketmind.controller;

import com.pocketmind.model.Memory;
import com.pocketmind.resolver.MemoryResolver;
import com.pocketmind.service.MemoryService;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/callback")
@Slf4j
public class AIWorkerCallbackController {
    @Autowired
    private MemoryService memoryService;
    
    @Autowired
    private MemoryResolver memoryResolver;
    
    @PostMapping("/process-complete")
    public ResponseEntity<Void> handleProcessComplete(@RequestBody ProcessCompleteRequest request) {
        try {
            Memory memory = memoryService.updateMemoryContent(
                    request.getMemoryId(),
                    request.getContent(),
                    request.getSummary(),
                    request.getEmbeddingId()
            );
            
            // Notify GraphQL subscribers
            memoryResolver.notifyMemoryUpdate(memory);
            
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            log.error("Error handling process complete callback", e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @Data
    static class ProcessCompleteRequest {
        private Long memoryId;
        private String content;
        private String summary;
        private String embeddingId;
    }
}

