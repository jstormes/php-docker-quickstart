# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the official Slim Framework 4 skeleton application for rapid development of web applications and APIs. It provides a clean foundation for building various types of web applications including REST APIs, web services, microservices, and traditional web applications. The skeleton follows clean architecture principles with Domain-Driven Design (DDD) patterns, using PHP-DI for dependency injection and Monolog for logging.

## Development Commands

```bash
# Start development server
composer start
# Alternative: php -S localhost:8080 -t public

# Run all tests
composer test
# Alternative: vendor/bin/phpunit

# Check coding standards (PSR-12)
vendor/bin/phpcs

# Run static analysis
vendor/bin/phpstan

# Fix coding standard violations
vendor/bin/phpcbf
```

## Architecture

The application follows a layered architecture:

### Domain Layer (`src/Domain/`)
- Contains core business logic and entities
- Domain entities (e.g., `User.php`)
- Repository interfaces (e.g., `UserRepository.php`)
- Domain exceptions and value objects

### Application Layer (`src/Application/`)
- **Actions**: HTTP request handlers that coordinate domain operations
- **Settings**: Application configuration management
- **Middleware**: Cross-cutting concerns (authentication, CORS, etc.)
- **Handlers**: Error handling and response processing
- **ResponseEmitter**: Custom response emission logic

### Infrastructure Layer (`src/Infrastructure/`)
- Implementation of domain repository interfaces
- External service integrations
- Persistence layer (currently in-memory implementations)

## Key Patterns

### Action Pattern
All HTTP endpoints are handled by Action classes that extend the base `Action` class (`src/Application/Actions/Action.php`). Actions follow this structure:
- Receive Request/Response via `__invoke()`
- Implement business logic in `action()` method
- Use `respondWithData()` for JSON responses
- Handle domain exceptions automatically

### Repository Pattern
Domain repositories are interfaces in the Domain layer with concrete implementations in Infrastructure. Current example:
- Interface: `src/Domain/User/UserRepository.php`
- Implementation: `src/Infrastructure/Persistence/User/InMemoryUserRepository.php`

### Dependency Injection
- Configuration in `app/dependencies.php`
- Settings managed in `app/settings.php`
- Uses PHP-DI container

## Configuration Files

- **Routes**: `app/routes.php` - HTTP route definitions
- **Dependencies**: `app/dependencies.php` - DI container configuration
- **Settings**: `app/settings.php` - Application settings
- **Bootstrap**: `public/index.php` - Application entry point

## Testing

- PHPUnit configuration: `phpunit.xml`
- Test files in `tests/` directory
- Bootstrap file: `tests/bootstrap.php`
- Follows PHPUnit 9.x conventions

## Code Quality

- **Coding Standard**: PSR-12 (configured in `phpcs.xml`)
- **Static Analysis**: PHPStan level 4 (configured in `phpstan.neon.dist`)
- **PHP Version**: Requires PHP 7.4+ or 8.0+
- All code uses strict typing (`declare(strict_types=1)`)

## Adding New Features

1. **New Entity**: Create in `src/Domain/EntityName/`
2. **Repository**: Interface in Domain, implementation in Infrastructure
3. **Actions**: Create action classes in `src/Application/Actions/EntityName/`
4. **Routes**: Add routes in `app/routes.php`
5. **Tests**: Add corresponding tests in `tests/`

## Environment Setup

For Docker development:
```bash
docker-compose up -d
```
Application runs on `http://localhost:8080`