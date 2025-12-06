package com.pocketmind.domain.model;

/**
 * Domain value object representing file types
 */
public enum FileType {
    AUDIO,
    IMAGE,
    TEXT;

    public String getDisplayName() {
        return name().charAt(0) + name().substring(1).toLowerCase();
    }
}

