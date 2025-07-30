-- Tree Database Schema
-- Version: 1.0
-- Description: Database schema for storing multiple tree structures using Composite pattern
-- Generated: 2025-07-30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table structure for table `trees`
-- --------------------------------------------------------

CREATE TABLE `trees` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL COMMENT 'Tree name/identifier',
    `description` text DEFAULT NULL COMMENT 'Optional description',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Soft delete flag',
    PRIMARY KEY (`id`),
    KEY `idx_trees_active` (`is_active`),
    KEY `idx_trees_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores multiple tree structures';

-- --------------------------------------------------------
-- Table structure for table `tree_nodes`
-- --------------------------------------------------------

CREATE TABLE `tree_nodes` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `tree_id` int(11) NOT NULL COMMENT 'Foreign key to trees table',
    `parent_id` int(11) DEFAULT NULL COMMENT 'Self-referencing foreign key, NULL for root nodes',
    `name` varchar(255) NOT NULL COMMENT 'Node name',
    `has_button` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether node has button',
    `button_text` varchar(100) DEFAULT NULL COMMENT 'Button text if applicable',
    `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Position within siblings',
    `depth` int(11) NOT NULL DEFAULT 0 COMMENT 'Tree depth level (0 for root)',
    `path` varchar(1000) DEFAULT NULL COMMENT 'Materialized path for queries',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
    PRIMARY KEY (`id`),
    KEY `idx_tree_nodes_tree_id` (`tree_id`),
    KEY `idx_tree_nodes_parent_id` (`parent_id`),
    -- KEY `idx_tree_nodes_path` (`path`), -- Removed due to key length limit (varchar(1000))
    KEY `idx_tree_nodes_depth` (`depth`),
    KEY `idx_tree_nodes_sort_order` (`sort_order`),
    KEY `idx_tree_nodes_tree_parent_sort` (`tree_id`, `parent_id`, `sort_order`),
    -- KEY `idx_tree_nodes_tree_depth_path` (`tree_id`, `depth`, `path`), -- Removed due to key length limit
    KEY `idx_tree_nodes_tree_depth` (`tree_id`, `depth`), -- Optimized composite index
    KEY `idx_tree_nodes_has_button` (`has_button`), -- For filtering nodes with buttons
    KEY `idx_tree_nodes_created_at` (`created_at`), -- For time-based queries
    CONSTRAINT `fk_tree_nodes_tree_id` FOREIGN KEY (`tree_id`) REFERENCES `trees` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_tree_nodes_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `tree_nodes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores individual tree nodes with hierarchy';

-- --------------------------------------------------------
-- Table structure for table `tree_node_metadata`
-- --------------------------------------------------------

CREATE TABLE `tree_node_metadata` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `node_id` int(11) NOT NULL COMMENT 'Foreign key to tree_nodes table',
    `key` varchar(100) NOT NULL COMMENT 'Metadata key',
    `value` text DEFAULT NULL COMMENT 'Metadata value',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_node_metadata_key` (`node_id`, `key`),
    KEY `idx_tree_node_metadata_node_id` (`node_id`),
    KEY `idx_tree_node_metadata_key` (`key`),
    CONSTRAINT `fk_tree_node_metadata_node_id` FOREIGN KEY (`node_id`) REFERENCES `tree_nodes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stores optional metadata for tree nodes';

-- --------------------------------------------------------
-- Sample data for testing
-- --------------------------------------------------------

-- Insert sample trees
INSERT INTO `trees` (`id`, `name`, `description`, `created_at`, `updated_at`, `is_active`) VALUES
(1, 'Company Structure', 'Organizational chart for the company', NOW(), NOW(), 1),
(2, 'File System', 'File system tree structure', NOW(), NOW(), 1),
(3, 'Menu System', 'Website navigation menu', NOW(), NOW(), 1);

-- Insert sample tree nodes for Company Structure (Tree ID: 1)
INSERT INTO `tree_nodes` (`id`, `tree_id`, `parent_id`, `name`, `has_button`, `button_text`, `sort_order`, `depth`, `path`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 'CEO', 1, 'Manage', 0, 0, '1', NOW(), NOW()),
(2, 1, 1, 'CTO', 0, NULL, 0, 1, '1.2', NOW(), NOW()),
(3, 1, 1, 'CFO', 0, NULL, 1, 1, '1.3', NOW(), NOW()),
(4, 1, 2, 'Dev Team', 0, NULL, 0, 2, '1.2.4', NOW(), NOW()),
(5, 1, 2, 'QA Team', 0, NULL, 1, 2, '1.2.5', NOW(), NOW()),
(6, 1, 3, 'Finance Team', 0, NULL, 0, 2, '1.3.6', NOW(), NOW());

-- Insert sample tree nodes for File System (Tree ID: 2)
INSERT INTO `tree_nodes` (`id`, `tree_id`, `parent_id`, `name`, `has_button`, `button_text`, `sort_order`, `depth`, `path`, `created_at`, `updated_at`) VALUES
(7, 2, NULL, 'Root', 0, NULL, 0, 0, '7', NOW(), NOW()),
(8, 2, 7, 'Documents', 0, NULL, 0, 1, '7.8', NOW(), NOW()),
(9, 2, 7, 'Pictures', 0, NULL, 1, 1, '7.9', NOW(), NOW()),
(10, 2, 8, 'Work', 0, NULL, 0, 2, '7.8.10', NOW(), NOW()),
(11, 2, 8, 'Personal', 0, NULL, 1, 2, '7.8.11', NOW(), NOW()),
(12, 2, 9, 'Vacation', 0, NULL, 0, 2, '7.9.12', NOW(), NOW());

-- Insert sample tree nodes for Menu System (Tree ID: 3)
INSERT INTO `tree_nodes` (`id`, `tree_id`, `parent_id`, `name`, `has_button`, `button_text`, `sort_order`, `depth`, `path`, `created_at`, `updated_at`) VALUES
(13, 3, NULL, 'Home', 0, NULL, 0, 0, '13', NOW(), NOW()),
(14, 3, NULL, 'Products', 1, 'View All', 1, 0, '14', NOW(), NOW()),
(15, 3, NULL, 'About', 0, NULL, 2, 0, '15', NOW(), NOW()),
(16, 3, 14, 'Software', 0, NULL, 0, 1, '14.16', NOW(), NOW()),
(17, 3, 14, 'Hardware', 0, NULL, 1, 1, '14.17', NOW(), NOW()),
(18, 3, 16, 'Desktop Apps', 0, NULL, 0, 2, '14.16.18', NOW(), NOW()),
(19, 3, 16, 'Mobile Apps', 0, NULL, 1, 2, '14.16.19', NOW(), NOW());

-- Insert sample metadata
INSERT INTO `tree_node_metadata` (`node_id`, `key`, `value`, `created_at`) VALUES
(1, 'department', 'Executive', NOW()),
(1, 'employee_count', '1', NOW()),
(2, 'department', 'Technology', NOW()),
(2, 'employee_count', '15', NOW()),
(3, 'department', 'Finance', NOW()),
(3, 'employee_count', '8', NOW()),
(7, 'file_type', 'directory', NOW()),
(8, 'file_type', 'directory', NOW()),
(9, 'file_type', 'directory', NOW()),
(13, 'menu_type', 'main', NOW()),
(14, 'menu_type', 'dropdown', NOW()),
(15, 'menu_type', 'main', NOW());

COMMIT; 