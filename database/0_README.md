# Database Initialization

This directory contains SQL files that are automatically executed when the MariaDB container starts for the first time. **This directory is specifically for database creation and population scripts only.** 

## 📋 Directory Purpose
- **Table Creation**: SQL files that create database tables, indexes, and constraints
- **Data Population**: SQL files that insert initial/sample data into tables
- **Schema Setup**: Files that establish the basic database structure

**Note**: Queries, stored procedures, views, and other operational SQL should be placed in the root directory or appropriate application directories.

## 🚀 How It Works

When the MariaDB container starts for the first time, it automatically executes files in this directory in alphabetical order. The files are executed against the database specified by the `MYSQL_DATABASE` environment variable in `docker-compose.yml`.

### Supported File Types
- **`.sql`** - SQL scripts for table creation and data population (most common)
- **`.sql.gz`** - Compressed SQL scripts
- **`.sql.xz`** - XZ compressed SQL scripts
- **`.sh`** - Shell scripts (with execute permission)

### What Goes Here
✅ **Appropriate for this directory:**
- CREATE TABLE statements
- INSERT statements for initial data
- ALTER TABLE statements for schema changes
- CREATE INDEX statements
- Foreign key constraints

❌ **Not appropriate for this directory:**
- SELECT queries
- Stored procedures
- Views
- Triggers
- Complex business logic queries

### Execution Order
Files are executed in alphabetical order by filename. Use 3-digit numbered prefixes (like `001_`, `002_`, etc.) to control execution order. This provides better organization and allows for more granular control.

## 📁 Current Files

### `001_StartupTables.sql`
- Creates the initial database schema
- Sets up the `SomeTable` with basic structure
- Includes proper indexing and auto-increment configuration

## 🔧 Customization

### Adding New Tables
1. Create a new `.sql` file in this directory
2. Use a 3-digit numbered prefix to control execution order
3. Example: `002_UsersTable.sql`, `003_ProductsTable.sql`

### Example: Adding a Users Table
```sql
-- 002_UsersTable.sql
CREATE TABLE `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `email` varchar(100) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`),
    UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Adding Initial Data
```sql
-- 004_InitialData.sql
INSERT INTO `users` (`username`, `email`) VALUES
('admin', 'admin@example.com'),
('user1', 'user1@example.com');
```

### Recommended File Naming Convention
- `001_Schema.sql` - Core schema definitions
- `002_Users.sql` - User-related tables
- `003_Products.sql` - Product-related tables
- `004_InitialData.sql` - Initial data insertion
- `005_Indexes.sql` - Additional indexes
- `006_Views.sql` - Database views
- `007_StoredProcedures.sql` - Stored procedures
- `008_Triggers.sql` - Database triggers

## 🛠️ Development Workflow

### 1. Modify Database Schema
1. Edit or add SQL files in this directory
2. Stop the containers: `docker-compose down`
3. Remove the database volume: `docker volume rm php-docker-quickstart_mariadb_data`
4. Restart: `docker-compose up -d`

### 2. Test Changes
1. Check PhpMyAdmin at http://localhost:7088
2. Verify tables and data are created correctly
3. Test your application's database functionality

### 3. Production Considerations
- Review all SQL files before deployment
- Ensure proper indexing for performance
- Consider data migration strategies for existing databases

## 📋 Best Practices

### File Naming
- Use descriptive names: `001_Schema.sql`, `002_Users.sql`, `003_Products.sql`
- Use 3-digit numbered prefixes for execution order
- Include version numbers if needed: `001_Schema_v1.2.sql`
- Use consistent naming conventions across all files

### SQL Structure
- Include proper comments explaining the purpose
- Use consistent naming conventions
- Add appropriate indexes for performance
- Include foreign key constraints where needed

### Error Handling
- Use `IF NOT EXISTS` for table creation
- Handle duplicate data gracefully
- Test scripts in development before production

## 🆘 Troubleshooting

### Database Not Initializing
1. Check container logs: `docker-compose logs mariadb`
2. Verify file permissions and syntax
3. Ensure files have `.sql` extension
4. Check for SQL syntax errors

### Changes Not Applied
1. Database volume may be persistent
2. Remove volume: `docker volume rm php-docker-quickstart_mariadb_data`
3. Restart containers: `docker-compose up -d`

### File Execution Order Issues
1. Check alphabetical ordering of filenames
2. Use 3-digit numbered prefixes to control order
3. Verify file extensions are supported

## 📚 Additional Resources

- [MariaDB Documentation](https://mariadb.com/kb/en/)
- [Docker MariaDB Image](https://hub.docker.com/_/mariadb)
- [SQL Best Practices](https://www.sqlstyle.guide/)

---

**Note**: Changes to files in this directory only affect new database instances. Existing databases with persistent volumes will not be reinitialized.