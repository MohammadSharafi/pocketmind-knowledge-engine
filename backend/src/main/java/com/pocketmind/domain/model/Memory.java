package com.pocketmind.domain.model;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

/**
 * Domain entity - pure business logic, no framework dependencies
 * This is the core domain model representing a Memory in the business domain
 */
public class Memory {
    private Long id;
    private String title;
    private String content;
    private String summary;
    private String fileUrl;
    private FileType fileType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private ProcessingStatus processingStatus;
    private String embeddingId;
    private Set<Tag> tags;

    public Memory() {
        this.tags = new HashSet<>();
    }

    public Memory(String title, FileType fileType) {
        this();
        this.title = title;
        this.fileType = fileType;
        this.processingStatus = ProcessingStatus.PENDING;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Business logic methods
    public boolean isProcessed() {
        return ProcessingStatus.COMPLETED.equals(processingStatus);
    }

    public boolean isProcessing() {
        return ProcessingStatus.PROCESSING.equals(processingStatus);
    }

    public boolean hasFailed() {
        return ProcessingStatus.FAILED.equals(processingStatus);
    }

    public void markAsProcessing() {
        if (ProcessingStatus.PENDING.equals(processingStatus)) {
            this.processingStatus = ProcessingStatus.PROCESSING;
            this.updatedAt = LocalDateTime.now();
        }
    }

    public void markAsCompleted(String content, String summary, String embeddingId) {
        this.content = content;
        this.summary = summary;
        this.embeddingId = embeddingId;
        this.processingStatus = ProcessingStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }

    public void markAsFailed() {
        this.processingStatus = ProcessingStatus.FAILED;
        this.updatedAt = LocalDateTime.now();
    }

    public void addTag(Tag tag) {
        if (tag != null) {
            this.tags.add(tag);
        }
    }

    public void removeTag(Tag tag) {
        if (tag != null) {
            this.tags.remove(tag);
        }
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Title cannot be null or empty");
        }
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public FileType getFileType() {
        return fileType;
    }

    public void setFileType(FileType fileType) {
        if (fileType == null) {
            throw new IllegalArgumentException("FileType cannot be null");
        }
        this.fileType = fileType;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public ProcessingStatus getProcessingStatus() {
        return processingStatus;
    }

    public void setProcessingStatus(ProcessingStatus processingStatus) {
        if (processingStatus == null) {
            throw new IllegalArgumentException("ProcessingStatus cannot be null");
        }
        this.processingStatus = processingStatus;
    }

    public String getEmbeddingId() {
        return embeddingId;
    }

    public void setEmbeddingId(String embeddingId) {
        this.embeddingId = embeddingId;
    }

    public Set<Tag> getTags() {
        return new HashSet<>(tags); // Return defensive copy
    }

    public void setTags(Set<Tag> tags) {
        this.tags = tags != null ? new HashSet<>(tags) : new HashSet<>();
    }
}

