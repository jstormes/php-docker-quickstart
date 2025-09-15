# My Slim Framework Project

A modern web application built with Slim Framework 4, featuring clean architecture and Domain-Driven Design principles.

## Getting Started

### Prerequisites

- PHP 8.2 or higher
- Composer

### Installation

1. Install dependencies:
   ```bash
   composer install
   ```

2. Start the development server:
   ```bash
   composer start
   ```

3. Visit `http://localhost:8080` in your browser

### Development with Docker

Alternatively, you can use Docker:

```bash
docker-compose up -d
```

## Project Structure

This project follows a clean architecture pattern:

- **`src/Domain/`** - Core business logic, entities, and repository interfaces
- **`src/Application/`** - Application layer with actions, middleware, and handlers
- **`src/Infrastructure/`** - Implementation of repositories and external services
- **`app/`** - Application configuration (routes, dependencies, settings)
- **public/`** - Web server document root
- **tests/`** - Test suite

## Development Commands

```bash
# Start development server
composer start

# Run tests
composer test

# Check code standards (PSR-12)
vendor/bin/phpcs

# Fix code standards
vendor/bin/phpcbf

# Run static analysis
vendor/bin/phpstan
```

## Adding New Features

1. **Create Domain Entity**: Add new entities in `src/Domain/EntityName/`
2. **Define Repository Interface**: Create repository interface in the domain layer
3. **Implement Repository**: Add concrete implementation in `src/Infrastructure/Persistence/`
4. **Create Actions**: Build action classes in `src/Application/Actions/EntityName/`
5. **Configure Routes**: Add routes in `app/routes.php`
6. **Register Dependencies**: Wire up dependencies in `app/repositories.php`

## Configuration

- **Application Settings**: `app/settings.php`
- **Dependencies**: `app/dependencies.php`
- **Routes**: `app/routes.php`
- **Middleware**: `app/middleware.php`

## Testing

Run the test suite:

```bash
composer test
```

Tests are located in the `tests/` directory and follow PHPUnit conventions.

## Code Quality

This project maintains high code quality standards:

- **PSR-12** coding standards
- **PHPStan** static analysis (level 4)
- **Strict typing** enabled throughout
- **Clean architecture** principles

## License

This project is licensed under the MIT License.