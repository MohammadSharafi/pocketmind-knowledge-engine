package com.pocketmind.controller;

import com.pocketmind.model.FileType;
import com.pocketmind.model.Memory;
import com.pocketmind.service.MemoryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/upload")
@Slf4j
public class FileUploadController {
    @Autowired
    private MemoryService memoryService;
    
    @PostMapping("/audio")
    public ResponseEntity<Memory> uploadAudio(@RequestParam("file") MultipartFile file) {
        try {
            Memory memory = memoryService.createMemoryFromFile(file, FileType.AUDIO);
            return ResponseEntity.ok(memory);
        } catch (Exception e) {
            log.error("Error uploading audio", e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    @PostMapping("/image")
    public ResponseEntity<Memory> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            Memory memory = memoryService.createMemoryFromFile(file, FileType.IMAGE);
            return ResponseEntity.ok(memory);
        } catch (Exception e) {
            log.error("Error uploading image", e);
            return ResponseEntity.internalServerError().build();
        }
    }
}

