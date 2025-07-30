-- Tree Path Query Optimizations
-- Version: 1.0
-- Description: Alternative approaches for path-based queries since full path indexing is not possible
-- Generated: 2025-07-30

-- --------------------------------------------------------
-- Alternative Approaches for Path-Based Queries
-- --------------------------------------------------------

-- Option 1: Add a shorter path hash column for indexing
-- This allows us to index a shorter representation of the path
ALTER TABLE `tree_nodes` 
ADD COLUMN `path_hash` varchar(64) DEFAULT NULL COMMENT 'MD5 hash of path for indexing' AFTER `path`,
ADD KEY `idx_tree_nodes_path_hash` (`path_hash`);

-- Update existing data with path hashes
UPDATE `tree_nodes` SET `path_hash` = MD5(`path`) WHERE `path` IS NOT NULL;

-- Option 2: Add a path level column for better querying
-- This stores the number of levels in the path (e.g., "1.2.4" = 3 levels)
ALTER TABLE `tree_nodes` 
ADD COLUMN `path_levels` int(11) DEFAULT NULL COMMENT 'Number of levels in path' AFTER `path_hash`,
ADD KEY `idx_tree_nodes_path_levels` (`path_levels`);

-- Update existing data with path levels
UPDATE `tree_nodes` 
SET `path_levels` = (LENGTH(`path`) - LENGTH(REPLACE(`path`, '.', '')) + 1) 
WHERE `path` IS NOT NULL;

-- Option 3: Add a root node ID column for faster ancestor queries
-- This stores the ID of the root node for each tree node
ALTER TABLE `tree_nodes` 
ADD COLUMN `root_node_id` int(11) DEFAULT NULL COMMENT 'ID of the root node' AFTER `path_levels`,
ADD KEY `idx_tree_nodes_root_node_id` (`root_node_id`);

-- Update existing data with root node IDs
UPDATE `tree_nodes` tn1
JOIN `tree_nodes` tn2 ON tn1.tree_id = tn2.tree_id AND tn2.parent_id IS NULL
SET tn1.root_node_id = tn2.id
WHERE tn1.tree_id = tn1.tree_id;

-- --------------------------------------------------------
-- Optimized Queries Using New Indexes
-- --------------------------------------------------------

-- Get all descendants using path hash (faster than LIKE queries)
-- This query uses the indexed path_hash instead of the long path column
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.path_hash = MD5('1.2')  -- Replace with actual path hash
ORDER BY tn.path;

-- Get nodes by path level (useful for depth-based queries)
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.path_levels = 3  -- Get all nodes at level 3
AND tn.tree_id = 1
ORDER BY tn.path;

-- Get all descendants using root node ID (alternative approach)
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.root_node_id = 1  -- Get all descendants of root node 1
AND tn.id != 1  -- Exclude the root node itself
ORDER BY tn.path;

-- --------------------------------------------------------
-- Stored Procedures for Path Operations
-- --------------------------------------------------------

-- Procedure to add a new node with automatic path hash and level calculation
DELIMITER //
CREATE PROCEDURE AddTreeNodeOptimized(
    IN p_tree_id INT,
    IN p_parent_id INT,
    IN p_name VARCHAR(255),
    IN p_has_button BOOLEAN,
    IN p_button_text VARCHAR(100),
    IN p_sort_order INT
)
BEGIN
    DECLARE new_depth INT;
    DECLARE new_path VARCHAR(1000);
    DECLARE new_path_hash VARCHAR(64);
    DECLARE new_path_levels INT;
    DECLARE new_id INT;
    DECLARE root_node_id INT;
    
    -- Calculate depth and path
    IF p_parent_id IS NULL THEN
        SET new_depth = 0;
        SET new_path = NULL;
        SET new_path_hash = NULL;
        SET new_path_levels = 1;
    ELSE
        SELECT depth + 1, CONCAT(path, '.', id) INTO new_depth, new_path
        FROM tree_nodes WHERE id = p_parent_id;
        SET new_path_hash = MD5(new_path);
        SET new_path_levels = (LENGTH(new_path) - LENGTH(REPLACE(new_path, '.', '')) + 1);
    END IF;
    
    -- Get root node ID
    SELECT id INTO root_node_id FROM tree_nodes 
    WHERE tree_id = p_tree_id AND parent_id IS NULL LIMIT 1;
    
    -- Insert new node
    INSERT INTO tree_nodes (tree_id, parent_id, name, has_button, button_text, sort_order, depth, path, path_hash, path_levels, root_node_id)
    VALUES (p_tree_id, p_parent_id, p_name, p_has_button, p_button_text, p_sort_order, new_depth, new_path, new_path_hash, new_path_levels, root_node_id);
    
    -- Get the new node ID
    SET new_id = LAST_INSERT_ID();
    
    -- Update path with the new node ID
    IF new_path IS NOT NULL THEN
        UPDATE tree_nodes 
        SET path = CONCAT(new_path, '.', new_id),
            path_hash = MD5(CONCAT(new_path, '.', new_id)),
            path_levels = (LENGTH(CONCAT(new_path, '.', new_id)) - LENGTH(REPLACE(CONCAT(new_path, '.', new_id), '.', '')) + 1)
        WHERE id = new_id;
    END IF;
    
    SELECT new_id as new_node_id;
END //
DELIMITER ;

-- Procedure to get descendants using optimized indexes
DELIMITER //
CREATE PROCEDURE GetDescendantsOptimized(IN node_id INT)
BEGIN
    DECLARE node_path VARCHAR(1000);
    DECLARE node_path_hash VARCHAR(64);
    
    -- Get the node's path and hash
    SELECT path, path_hash INTO node_path, node_path_hash
    FROM tree_nodes WHERE id = node_id;
    
    -- Get all descendants using path hash (much faster)
    SELECT 
        tn.*,
        t.name as tree_name
    FROM tree_nodes tn
    JOIN trees t ON tn.tree_id = t.id
    WHERE tn.path_hash LIKE CONCAT(node_path_hash, '%')
    AND tn.id != node_id
    ORDER BY tn.path;
END //
DELIMITER ;

-- --------------------------------------------------------
-- Performance Comparison Queries
-- --------------------------------------------------------

-- Slow query (original approach - uses LIKE on long path)
-- SELECT * FROM tree_nodes WHERE path LIKE '1.2.%';

-- Fast query (new approach - uses indexed path_hash)
-- SELECT * FROM tree_nodes WHERE path_hash LIKE MD5('1.2') || '%';

-- --------------------------------------------------------
-- Migration Notes
-- --------------------------------------------------------

-- If you want to implement these optimizations:
-- 1. Run the ALTER TABLE statements to add the new columns
-- 2. Update existing data with the calculated values
-- 3. Update your application code to use the new optimized queries
-- 4. Consider dropping the original path-based queries for better performance

-- The path_hash approach provides the best balance of:
-- - Query performance (indexed lookups)
-- - Storage efficiency (64-byte hash vs 1000-byte path)
-- - Maintainability (automatic calculation in stored procedures) 