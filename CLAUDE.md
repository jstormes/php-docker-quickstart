# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a PHP Docker Quickstart project that provides a complete PHP development environment with Docker, featuring:
- PHP 8.x with Slim Framework 4 skeleton application
- MariaDB database server with PhpMyAdmin interface
- xDebug debugging support with PhpStorm integration
- Development, testing, and production Docker configurations

## Essential Commands

### Docker Environment Management
```bash
# Start development environment
docker-compose up -d

# Stop all services
docker-compose down

# Rebuild containers
docker-compose up --build

# View logs
docker-compose logs php-dev

# Access container shell (REQUIRED for all PHP commands)
docker-compose exec php-dev bash

# Run production build
docker-compose -f docker-compose.yml up php-prod --build
```

### PHP Application Commands
**⚠️ IMPORTANT: All PHP commands must be run inside the container. Use `docker-compose exec php-dev bash` first.**

```bash
# From host: Run commands inside container
docker-compose exec php-dev composer install
docker-compose exec php-dev composer test
docker-compose exec php-dev vendor/bin/phpcs
docker-compose exec php-dev vendor/bin/phpstan

# OR: First access container shell, then run commands
docker-compose exec php-dev bash
# Now inside container:
composer install
composer test
vendor/bin/phpunit
vendor/bin/phpcs
vendor/bin/phpcbf
vendor/bin/phpstan
composer start
```

### Testing Commands
**⚠️ IMPORTANT: Must be run inside the Docker container**

```bash
# From host (recommended)
docker-compose exec php-dev ./self-test.sh
docker-compose exec php-dev vendor/bin/phpunit
docker-compose exec php-dev vendor/bin/phpunit tests/Application/Actions/ActionTest.php

# Inside container (after docker-compose exec php-dev bash)
./self-test.sh
vendor/bin/phpunit
vendor/bin/phpunit tests/Application/Actions/ActionTest.php
vendor/bin/phpunit --coverage-html coverage
```

## Architecture Overview

### Docker Services
- **php-dev**: Development server with xDebug (port 8088)
- **php-prod**: Production-like server without debug tools (port 9088)
- **ci-cd-test**: Testing environment (port 5088)
- **mariadb**: Database server (port 5000)
- **phpmyadmin**: Database management interface (port 7088)

### PHP Application Structure
Based on Slim Framework 4 skeleton with clean architecture:

- **Domain Layer** (`app/src/Domain/`): Core business logic and entities
- **Application Layer** (`app/src/Application/`): HTTP handlers, middleware, settings
- **Infrastructure Layer** (`app/src/Infrastructure/`): Repository implementations
- **Public** (`app/public/`): Web root with entry point
- **Tests** (`app/tests/`): PHPUnit test suite

### Key Configuration Files
- `docker-compose.yml`: Main Docker services configuration
- `Dockerfile`: Multi-stage Docker build (base, dev, test, prod)
- `app/composer.json`: PHP dependencies and scripts
- `app/phpunit.xml`: PHPUnit testing configuration
- `app/phpcs.xml`: PHP CodeSniffer coding standards (PSR-12)
- `app/phpstan.neon.dist`: PHPStan static analysis configuration

## Development Workflow

### Setting Up Development
1. Start services: `docker-compose up -d`
2. Access container: `docker-compose exec php-dev bash`
3. Install dependencies: `docker-compose exec php-dev bash composer install`
4. Run tests: `docker-compose exec php-dev bash composer test`

### Access Points
- **Development Application**: http://localhost:8088
- **Production Application**: http://localhost:9088
- **PhpMyAdmin**: http://localhost:7088
- **Database Connection**: localhost:5000 (root/password)

### xDebug Configuration
- IDE Key: `PHPSTORM`
- Host mapping: `host.docker.internal:host-gateway`
- Configuration files in `config/docker/xdebug_3.x.x.ini`
- Debugging workflow: Start PhpStorm listener → Use browser extension → Set breakpoints

### Code Quality Standards
- **PHP Version**: 8.2+
- **Coding Standard**: PSR-12 (enforced via phpcs)
- **Static Analysis**: PHPStan Level 4
- **Testing**: PHPUnit 9.x with coverage reporting
- **Architecture**: Clean Architecture with DDD patterns

## Claude AI Integration

The development environment includes Claude Code CLI pre-installed:
- Accessible via `claude --dangerously-skip-permissions` alias
- Configuration mounted from host `~/.claude/` directory
- API key passed through `ANTHROPIC_API_KEY` environment variable

## Important Notes

- **⚠️ CRITICAL: ALL PHP development commands must be run inside the Docker container**
- Always run quality checks before committing (inside container): `vendor/bin/phpcs && vendor/bin/phpstan && vendor/bin/phpunit`
- The `self-test.sh` script runs comprehensive testing in CI/CD environment
- Database initialization scripts are placed in `database/` directory
- xDebug profiling output is saved to `xdebug.info/` directory
- Use the development container for coding; production container for deployment testing
- Never run PHP commands directly on host - they will fail due to missing dependencies and configuration
- always use mariadb tool inside docker to access the database.