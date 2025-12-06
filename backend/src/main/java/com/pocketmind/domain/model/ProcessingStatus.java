package com.pocketmind.domain.model;

/**
 * Domain value object representing processing status
 */
public enum ProcessingStatus {
    PENDING,
    PROCESSING,
    COMPLETED,
    FAILED;

    public String getDisplayName() {
        return name().charAt(0) + name().substring(1).toLowerCase();
    }
}

