package com.pocketmind.domain.model;

import java.time.LocalDateTime;

/**
 * Domain entity representing a Tag
 */
public class Tag {
    private Long id;
    private String name;
    private String color;
    private LocalDateTime createdAt;

    public Tag() {
    }

    public Tag(String name) {
        this.name = name;
        this.createdAt = LocalDateTime.now();
    }

    public Tag(String name, String color) {
        this(name);
        this.color = color;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Tag name cannot be null or empty");
        }
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

