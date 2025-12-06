package com.pocketmind.queue;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class TaskQueueService {
    private static final String QUEUE_NAME = "ai.tasks";
    
    @Autowired
    private RabbitTemplate rabbitTemplate;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    public void publishTask(AITask task) {
        try {
            String message = objectMapper.writeValueAsString(task);
            rabbitTemplate.convertAndSend(QUEUE_NAME, message);
            log.info("Published AI task for memory: {}", task.getMemoryId());
        } catch (Exception e) {
            log.error("Error publishing task", e);
            throw new RuntimeException("Failed to publish task", e);
        }
    }
}

