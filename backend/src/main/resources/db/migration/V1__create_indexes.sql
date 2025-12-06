-- Database indexes for performance optimization
-- These indexes significantly improve query performance

-- Index on created_at for sorting and filtering
CREATE INDEX IF NOT EXISTS idx_memories_created_at ON memories(created_at DESC);

-- Index on file_type for filtering by type
CREATE INDEX IF NOT EXISTS idx_memories_file_type ON memories(file_type);

-- Index on processing_status for filtering by status
CREATE INDEX IF NOT EXISTS idx_memories_status ON memories(processing_status);

-- Index on title for text search (using GIN for full-text search)
CREATE INDEX IF NOT EXISTS idx_memories_title_gin ON memories USING gin(to_tsvector('english', title));

-- Index on tags relationship table
CREATE INDEX IF NOT EXISTS idx_memory_tags_memory_id ON memory_tags(memory_id);
CREATE INDEX IF NOT EXISTS idx_memory_tags_tag_id ON memory_tags(tag_id);

-- Index on tags name for quick lookup
CREATE INDEX IF NOT EXISTS idx_tags_name ON tags(name);

-- Composite index for common query patterns
CREATE INDEX IF NOT EXISTS idx_memories_status_created ON memories(processing_status, created_at DESC);

