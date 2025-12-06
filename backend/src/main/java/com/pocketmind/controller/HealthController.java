package com.pocketmind.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/health")
public class HealthController {
    
    @Autowired(required = false)
    private DataSource dataSource;
    
    @GetMapping
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "pocketmind-backend");
        health.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(health);
    }
    
    @GetMapping("/detailed")
    public ResponseEntity<Map<String, Object>> detailedHealth() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "pocketmind-backend");
        health.put("timestamp", System.currentTimeMillis());
        
        Map<String, String> components = new HashMap<>();
        
        // Check database
        components.put("database", checkDatabase());
        
        health.put("components", components);
        return ResponseEntity.ok(health);
    }
    
    private String checkDatabase() {
        if (dataSource == null) {
            return "UNKNOWN";
        }
        try (Connection conn = dataSource.getConnection()) {
            if (conn.isValid(2)) {
                return "UP";
            }
        } catch (Exception e) {
            return "DOWN: " + e.getMessage();
        }
        return "DOWN";
    }
}

