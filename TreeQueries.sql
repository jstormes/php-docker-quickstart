-- Tree Database Queries and Stored Procedures
-- Version: 1.0
-- Description: Useful queries and procedures for working with tree data
-- Generated: 2025-07-30

-- --------------------------------------------------------
-- Useful Queries for Tree Operations
-- --------------------------------------------------------

-- Get all trees with their node counts
SELECT 
    t.id,
    t.name,
    t.description,
    COUNT(tn.id) as node_count,
    t.created_at,
    t.is_active
FROM trees t
LEFT JOIN tree_nodes tn ON t.id = tn.tree_id
WHERE t.is_active = 1
GROUP BY t.id, t.name, t.description, t.created_at, t.is_active
ORDER BY t.name;

-- Get complete tree structure with hierarchy
SELECT 
    tn.id,
    tn.tree_id,
    tn.parent_id,
    tn.name,
    tn.has_button,
    tn.button_text,
    tn.sort_order,
    tn.depth,
    tn.path,
    CONCAT(REPEAT('  ', tn.depth), tn.name) as display_name
FROM tree_nodes tn
WHERE tn.tree_id = ?  -- Replace ? with tree_id
ORDER BY tn.path, tn.sort_order;

-- Get all children of a specific node
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.parent_id = ?  -- Replace ? with parent_node_id
ORDER BY tn.sort_order;

-- Get all descendants of a node (using path)
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.path LIKE CONCAT((SELECT path FROM tree_nodes WHERE id = ?), '.%')  -- Replace ? with node_id
ORDER BY tn.path;

-- Get all ancestors of a node
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE FIND_IN_SET(tn.id, (SELECT path FROM tree_nodes WHERE id = ?))  -- Replace ? with node_id
ORDER BY tn.depth;

-- Get siblings of a node
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.parent_id = (SELECT parent_id FROM tree_nodes WHERE id = ?)  -- Replace ? with node_id
AND tn.id != ?  -- Replace ? with node_id
ORDER BY tn.sort_order;

-- Get root nodes of all trees
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.parent_id IS NULL
AND t.is_active = 1
ORDER BY t.name, tn.sort_order;

-- Get nodes with buttons
SELECT 
    tn.*,
    t.name as tree_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE tn.has_button = 1
AND t.is_active = 1
ORDER BY t.name, tn.path;

-- Get tree statistics
SELECT 
    t.id,
    t.name,
    COUNT(tn.id) as total_nodes,
    COUNT(CASE WHEN tn.parent_id IS NULL THEN 1 END) as root_nodes,
    MAX(tn.depth) as max_depth,
    AVG(tn.depth) as avg_depth
FROM trees t
LEFT JOIN tree_nodes tn ON t.id = tn.tree_id
WHERE t.is_active = 1
GROUP BY t.id, t.name;

-- --------------------------------------------------------
-- Stored Procedures
-- --------------------------------------------------------

-- Procedure to get complete tree structure
DELIMITER //
CREATE PROCEDURE GetTreeStructure(IN tree_id INT)
BEGIN
    SELECT 
        tn.id,
        tn.parent_id,
        tn.name,
        tn.has_button,
        tn.button_text,
        tn.sort_order,
        tn.depth,
        tn.path,
        CONCAT(REPEAT('  ', tn.depth), tn.name) as display_name
    FROM tree_nodes tn
    WHERE tn.tree_id = tree_id
    ORDER BY tn.path, tn.sort_order;
END //
DELIMITER ;

-- Procedure to get node with all its children
DELIMITER //
CREATE PROCEDURE GetNodeWithChildren(IN node_id INT)
BEGIN
    SELECT 
        tn.*,
        t.name as tree_name
    FROM tree_nodes tn
    JOIN trees t ON tn.tree_id = t.id
    WHERE tn.id = node_id
    OR tn.path LIKE CONCAT((SELECT path FROM tree_nodes WHERE id = node_id), '.%')
    ORDER BY tn.path;
END //
DELIMITER ;

-- Procedure to add a new node
DELIMITER //
CREATE PROCEDURE AddTreeNode(
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
    DECLARE new_id INT;
    
    -- Calculate depth
    IF p_parent_id IS NULL THEN
        SET new_depth = 0;
        SET new_path = NULL;
    ELSE
        SELECT depth + 1, CONCAT(path, '.', id) INTO new_depth, new_path
        FROM tree_nodes WHERE id = p_parent_id;
    END IF;
    
    -- Insert new node
    INSERT INTO tree_nodes (tree_id, parent_id, name, has_button, button_text, sort_order, depth, path)
    VALUES (p_tree_id, p_parent_id, p_name, p_has_button, p_button_text, p_sort_order, new_depth, new_path);
    
    -- Get the new node ID
    SET new_id = LAST_INSERT_ID();
    
    -- Update path with the new node ID
    UPDATE tree_nodes 
    SET path = CONCAT(new_path, '.', new_id)
    WHERE id = new_id AND new_path IS NOT NULL;
    
    SELECT new_id as new_node_id;
END //
DELIMITER ;

-- Procedure to move a node (change parent)
DELIMITER //
CREATE PROCEDURE MoveTreeNode(
    IN p_node_id INT,
    IN p_new_parent_id INT
)
BEGIN
    DECLARE old_path VARCHAR(1000);
    DECLARE new_path VARCHAR(1000);
    DECLARE new_depth INT;
    
    -- Get current path
    SELECT path INTO old_path FROM tree_nodes WHERE id = p_node_id;
    
    -- Calculate new path and depth
    IF p_new_parent_id IS NULL THEN
        SET new_depth = 0;
        SET new_path = p_node_id;
    ELSE
        SELECT depth + 1, CONCAT(path, '.', p_node_id) INTO new_depth, new_path
        FROM tree_nodes WHERE id = p_new_parent_id;
    END IF;
    
    -- Update the node
    UPDATE tree_nodes 
    SET parent_id = p_new_parent_id, depth = new_depth, path = new_path
    WHERE id = p_node_id;
    
    -- Update all descendants' paths
    UPDATE tree_nodes 
    SET path = CONCAT(new_path, SUBSTRING(path, LENGTH(old_path) + 1))
    WHERE path LIKE CONCAT(old_path, '.%');
END //
DELIMITER ;

-- Procedure to delete a node and all its descendants
DELIMITER //
CREATE PROCEDURE DeleteTreeNode(IN p_node_id INT)
BEGIN
    DECLARE node_path VARCHAR(1000);
    
    -- Get the node path
    SELECT path INTO node_path FROM tree_nodes WHERE id = p_node_id;
    
    -- Delete all descendants
    DELETE FROM tree_nodes WHERE path LIKE CONCAT(node_path, '.%');
    
    -- Delete the node itself
    DELETE FROM tree_nodes WHERE id = p_node_id;
END //
DELIMITER ;

-- --------------------------------------------------------
-- Useful Views
-- --------------------------------------------------------

-- View for tree summary
CREATE VIEW tree_summary AS
SELECT 
    t.id,
    t.name,
    t.description,
    COUNT(tn.id) as node_count,
    COUNT(CASE WHEN tn.parent_id IS NULL THEN 1 END) as root_nodes,
    MAX(tn.depth) as max_depth,
    t.created_at,
    t.is_active
FROM trees t
LEFT JOIN tree_nodes tn ON t.id = tn.tree_id
GROUP BY t.id, t.name, t.description, t.created_at, t.is_active;

-- View for node hierarchy display
CREATE VIEW node_hierarchy AS
SELECT 
    tn.id,
    tn.tree_id,
    tn.parent_id,
    tn.name,
    tn.has_button,
    tn.button_text,
    tn.sort_order,
    tn.depth,
    tn.path,
    t.name as tree_name,
    CONCAT(REPEAT('  ', tn.depth), tn.name) as display_name,
    CONCAT(t.name, ' > ', tn.name) as full_name
FROM tree_nodes tn
JOIN trees t ON tn.tree_id = t.id
WHERE t.is_active = 1;

-- --------------------------------------------------------
-- Example Usage
-- --------------------------------------------------------

-- Example: Get Company Structure tree
-- CALL GetTreeStructure(1);

-- Example: Add a new node to Company Structure
-- CALL AddTreeNode(1, 2, 'New Team', 0, NULL, 2);

-- Example: Move a node
-- CALL MoveTreeNode(4, 3);

-- Example: Delete a node and its children
-- CALL DeleteTreeNode(5);

-- Example: Get node with all children
-- CALL GetNodeWithChildren(2); 