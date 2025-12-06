package com.pocketmind.service;

import com.pocketmind.model.Memory;
import com.pocketmind.repository.MemoryRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class SearchService {
    @Autowired
    private MemoryRepository memoryRepository;
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Value("${ai-worker.base-url}")
    private String aiWorkerBaseUrl;
    
    public List<SearchResult> semanticSearch(String query, int limit) {
        try {
            // Call Python AI worker to perform semantic search
            String url = aiWorkerBaseUrl + "/search";
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> request = new HashMap<>();
            request.put("query", query);
            request.put("limit", limit);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(request, headers);
            ResponseEntity<SearchResponse> response = restTemplate.postForEntity(
                    url, entity, SearchResponse.class);
            
            if (response.getBody() != null) {
                return response.getBody().getResults().stream()
                        .map(result -> {
                            Memory memory = memoryRepository.findById(result.getMemoryId())
                                    .orElse(null);
                            if (memory != null) {
                                return new SearchResult(memory, result.getScore());
                            }
                            return null;
                        })
                        .filter(result -> result != null)
                        .toList();
            }
        } catch (Exception e) {
            log.error("Error performing semantic search", e);
        }
        return List.of();
    }
    
    public static class SearchResult {
        private final Memory memory;
        private final Double score;
        
        public SearchResult(Memory memory, Double score) {
            this.memory = memory;
            this.score = score;
        }
        
        public Memory getMemory() { return memory; }
        public Double getScore() { return score; }
    }
    
    private static class SearchResponse {
        private List<SearchResultItem> results;
        
        public List<SearchResultItem> getResults() { return results; }
        public void setResults(List<SearchResultItem> results) { this.results = results; }
    }
    
    private static class SearchResultItem {
        private Long memoryId;
        private Double score;
        
        public Long getMemoryId() { return memoryId; }
        public void setMemoryId(Long memoryId) { this.memoryId = memoryId; }
        public Double getScore() { return score; }
        public void setScore(Double score) { this.score = score; }
    }
}

