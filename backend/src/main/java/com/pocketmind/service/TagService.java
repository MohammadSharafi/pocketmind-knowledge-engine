package com.pocketmind.service;

import com.pocketmind.model.Tag;
import com.pocketmind.repository.TagRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Slf4j
public class TagService {
    @Autowired
    private TagRepository tagRepository;
    
    public List<Tag> getAllTags() {
        return tagRepository.findAll();
    }
    
    @Transactional
    public Tag createTag(String name, String color) {
        Optional<Tag> existing = tagRepository.findByName(name);
        if (existing.isPresent()) {
            return existing.get();
        }
        Tag tag = new Tag();
        tag.setName(name);
        tag.setColor(color);
        return tagRepository.save(tag);
    }
    
    public Optional<Tag> getTagById(Long id) {
        return tagRepository.findById(id);
    }
}

