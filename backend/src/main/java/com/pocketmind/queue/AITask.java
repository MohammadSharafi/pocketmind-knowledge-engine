package com.pocketmind.queue;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AITask {
    private Long memoryId;
    private String fileUrl;
    private String fileType; // AUDIO, IMAGE, TEXT
    private String fileName;
}

