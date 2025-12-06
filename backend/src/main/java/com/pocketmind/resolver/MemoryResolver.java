package com.pocketmind.resolver;

import com.pocketmind.model.Memory;
import com.pocketmind.model.FileType;
import com.pocketmind.model.ProcessingStatus;
import com.pocketmind.model.Tag;
import com.pocketmind.service.MemoryService;
import com.pocketmind.service.SearchService;
import com.pocketmind.service.TagService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SubscriptionMapping;
import org.springframework.stereotype.Controller;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Controller
@Slf4j
public class MemoryResolver {
    @Autowired
    private MemoryService memoryService;
    
    @Autowired
    private TagService tagService;
    
    @Autowired
    private SearchService searchService;
    
    private final Map<Long, Sinks.Many<Memory>> memorySinks = new ConcurrentHashMap<>();
    
    @QueryMapping
    public List<Memory> memories(@Argument Integer limit, @Argument Integer offset) {
        List<Memory> all = memoryService.getAllMemories();
        int start = offset != null ? offset : 0;
        int end = limit != null ? Math.min(start + limit, all.size()) : all.size();
        return all.subList(start, Math.min(end, all.size()));
    }
    
    @QueryMapping
    public Memory memory(@Argument Long id) {
        return memoryService.getMemoryById(id)
                .orElseThrow(() -> new RuntimeException("Memory not found"));
    }
    
    @QueryMapping
    public List<SearchService.SearchResult> search(@Argument String query, @Argument Integer limit) {
        return searchService.semanticSearch(query, limit != null ? limit : 10);
    }
    
    @QueryMapping
    public List<Tag> tags() {
        return tagService.getAllTags();
    }
    
    
    @MutationMapping
    public Memory uploadText(@Argument String content, @Argument String title) {
        return memoryService.createMemoryFromText(content, title);
    }
    
    @MutationMapping
    public Tag createTag(@Argument String name, @Argument String color) {
        return tagService.createTag(name, color);
    }
    
    @MutationMapping
    public Memory addTagToMemory(@Argument Long memoryId, @Argument Long tagId) {
        return memoryService.addTag(memoryId, tagId);
    }
    
    @MutationMapping
    public Memory removeTagFromMemory(@Argument Long memoryId, @Argument Long tagId) {
        return memoryService.removeTag(memoryId, tagId);
    }
    
    @MutationMapping
    public Boolean deleteMemory(@Argument Long id) {
        memoryService.deleteMemory(id);
        return true;
    }
    
    @SubscriptionMapping
    public Flux<Memory> memoryProcessed(@Argument Long memoryId) {
        Sinks.Many<Memory> sink = memorySinks.computeIfAbsent(
                memoryId, k -> Sinks.many().multicast().onBackpressureBuffer());
        return sink.asFlux();
    }
    
    @SubscriptionMapping
    public Flux<Memory> memoryUpdated() {
        // For simplicity, we'll use a single sink for all updates
        // In production, you'd want more sophisticated routing
        Sinks.Many<Memory> sink = Sinks.many().multicast().onBackpressureBuffer();
        return sink.asFlux();
    }
    
    public void notifyMemoryUpdate(Memory memory) {
        Sinks.Many<Memory> sink = memorySinks.get(memory.getId());
        if (sink != null) {
            sink.tryEmitNext(memory);
        }
    }
}

