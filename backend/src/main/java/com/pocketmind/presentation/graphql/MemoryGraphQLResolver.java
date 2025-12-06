package com.pocketmind.presentation.graphql;

import com.pocketmind.application.dto.MemoryDTO;
import com.pocketmind.application.mapper.MemoryMapper;
import com.pocketmind.application.usecase.CreateMemoryUseCase;
import com.pocketmind.application.usecase.GetMemoriesUseCase;
import com.pocketmind.application.usecase.UpdateMemoryStatusUseCase;
import com.pocketmind.domain.model.Memory;
import com.pocketmind.domain.model.FileType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * GraphQL Resolver - Presentation layer
 * Uses application use cases, not domain directly
 */
@Controller
public class MemoryGraphQLResolver {
    private final GetMemoriesUseCase getMemoriesUseCase;
    private final CreateMemoryUseCase createMemoryUseCase;
    private final UpdateMemoryStatusUseCase updateMemoryStatusUseCase;
    private final MemoryMapper memoryMapper;

    @Autowired
    public MemoryGraphQLResolver(
            GetMemoriesUseCase getMemoriesUseCase,
            CreateMemoryUseCase createMemoryUseCase,
            UpdateMemoryStatusUseCase updateMemoryStatusUseCase,
            MemoryMapper memoryMapper) {
        this.getMemoriesUseCase = getMemoriesUseCase;
        this.createMemoryUseCase = createMemoryUseCase;
        this.updateMemoryStatusUseCase = updateMemoryStatusUseCase;
        this.memoryMapper = memoryMapper;
    }

    @QueryMapping
    public List<MemoryDTO> memories(@Argument Integer limit, @Argument Integer offset) {
        List<Memory> memories = getMemoriesUseCase.execute(limit, offset);
        return memories.stream()
                .map(memoryMapper::toDTO)
                .collect(Collectors.toList());
    }

    @MutationMapping
    public MemoryDTO uploadText(@Argument String content, @Argument String title) {
        Memory memory = createMemoryUseCase.execute(
                title != null ? title : "Text Note",
                content,
                FileType.TEXT
        );
        return memoryMapper.toDTO(memory);
    }
}

