# Contributing to PHP Docker Quickstart

Thank you for your interest in contributing to this PHP Docker Quickstart project! This guide will help you understand how to contribute effectively.

## How to Contribute

### 1. Fork and Clone

1. Fork this repository to your GitHub account
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/php-docker-quickstart.git
   cd php-docker-quickstart
   ```

### 2. Make Your Changes

1. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and test them:
   ```bash
   docker-compose up --build
   ```

3. Commit your changes with clear commit messages:
   ```bash
   git commit -m "Add feature: brief description of what you added"
   ```

### 3. Submit Your Changes

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a Pull Request from your fork to the main repository

## Customizing for Your Project

### 1. Update Project Information

- Edit `README.md` to reflect your project's purpose
- Update `docker-compose.yml` with your project name
- Replace the sample PHP code in `app/html/` with your application

### 2. Modify Docker Configuration

**Adding PHP Extensions:**
Edit the `Dockerfile` and add extensions to the appropriate target:
```dockerfile
# Add your required extensions
RUN docker-php-ext-install pdo_mysql mysqli
```

**Changing PHP Version:**
Update the base image in the Dockerfile:
```dockerfile
FROM php:8.2-apache
```

**Adding Environment Variables:**
Edit `docker-compose.yml`:
```yaml
environment:
  - MY_CUSTOM_VAR=value
  - ANOTHER_VAR=another_value
```

### 3. Database Customization

**Adding Database Schema:**
Create SQL files in `database/`:
```sql
-- database/002_UsersTable.sql
CREATE TABLE `users` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `username` varchar(50) NOT NULL,
    `email` varchar(100) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Adding Initial Data:**
Create SQL files in `database/`:
```sql
-- database/004_InitialData.sql
INSERT INTO users (name, email) VALUES ('Admin', 'admin@example.com');
```

**Changing Database Credentials:**
Update `docker-compose.yml`:
```yaml
environment:
  - MYSQL_ROOT_PASSWORD=your_secure_password
  - MYSQL_DATABASE=your_database_name
```

**Database Initialization:**
- Files in `database/` are executed in alphabetical order
- Use 3-digit numbered prefixes (001_, 002_, etc.) to control execution order
- See `database/0_README.md` for detailed documentation

### 4. Adding New Services

**Adding Redis:**
Add to `docker-compose.yml`:
```yaml
redis:
  image: redis:alpine
  ports:
    - "6379:6379"
```

**Adding Nginx:**
Add to `docker-compose.yml`:
```yaml
nginx:
  image: nginx:alpine
  ports:
    - "80:80"
  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf
```

## Development Guidelines

### Code Style

- Follow PSR-12 coding standards for PHP
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Documentation

- Update README.md when adding new features
- Document any new environment variables
- Include examples for new functionality
- Update SETUP.md if setup process changes

### Testing

- Test your changes with different PHP versions
- Verify Docker containers start correctly
- Test debugging functionality
- Check that database connections work

## Common Customizations

### 1. Adding Composer

Add to your Dockerfile:
```dockerfile
# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
```

### 2. Adding Node.js

Add to your Dockerfile:
```dockerfile
# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs
```

### 3. Adding Custom Apache Configuration

Create `apache.conf`:
```apache
<VirtualHost *:80>
    DocumentRoot /app/html
    <Directory /app/html>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

Add to Dockerfile:
```dockerfile
COPY apache.conf /etc/apache2/sites-available/000-default.conf
```

### 4. Adding SSL/HTTPS

Add to `docker-compose.yml`:
```yaml
ports:
  - "443:443"
volumes:
  - ./ssl:/etc/ssl/certs
```

## Troubleshooting Contributions

### Common Issues

**Build Failures:**
- Check Dockerfile syntax
- Verify base images exist
- Ensure all dependencies are available

**Port Conflicts:**
- Change port mappings in `docker-compose.yml`
- Check for other services using the same ports

**Permission Issues:**
- Ensure proper file permissions
- Check Docker user permissions

### Getting Help

1. Check existing issues and pull requests
2. Search for similar problems in the repository
3. Create a detailed issue with:
   - Your operating system
   - Docker version
   - Error messages
   - Steps to reproduce

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to make this project better for everyone! 