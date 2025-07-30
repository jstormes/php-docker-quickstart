# PHP Docker Quickstart

A ready-to-use PHP development environment with Docker, featuring PhpStorm integration and xDebug debugging support.

## 🚀 Quick Start

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- [PhpStorm](https://www.jetbrains.com/phpstorm/) (optional, for debugging)

### 1. Clone and Start
```bash
git clone git@github.com:jstormes/php-docker-quickstart.git
cd php-docker-quickstart
docker-compose up -d
```

### 2. Access Your Application
- **Development server**: http://localhost:8088
- **Production like server**: http://localhost:9088
- **PhpMyAdmin**: http://localhost:7088

## 📁 Project Structure

```
php-docker-quickstart/
├── app/                         # Your PHP application code
│   ├── public/                  # Web root directory (served by PHP dev server)
│   │   ├── index.php           # Main entry point
│   │   └── .htaccess           # Apache configuration
│   ├── src/                    # Application source code
│   ├── tests/                  # Test files
│   ├── var/                    # Application cache and logs
│   ├── vendor/                 # Composer dependencies
│   ├── composer.json           # PHP dependencies
│   └── phpunit.xml            # PHPUnit configuration
├── config/                      # Configuration files
│   └── docker/                  # Docker configuration files
│       ├── php.ini-development  # Development PHP configuration
│       ├── php.ini-production   # Production PHP configuration
│       └── xdebug_3.x.x.ini     # xDebug development settings
├── database/                    # Database initialization scripts
│   ├── 0_README.md              # Database setup documentation
│   └── 001_StartupTables.sql    # Initial database schema
├── xdebug.info/                 # xDebug profiling output directory
├── docker-compose.yml           # Main Docker configuration
├── Dockerfile                   # Docker image definition
├── README.md                    # This file
├── SETUP.md                     # Detailed setup guide
├── CONTRIBUTING.md              # How to contribute
├── QUICK_REFERENCE.md           # Quick reference guide
└── self-test.sh                 # Self-test script
```

## 🔧 Development Features

### PHP Development Environment
- **PHP 8.x** with common extensions
- **MariaDB** database server
- **PhpMyAdmin** for database management
- **Hot reload** - code changes reflect immediately
- **PHP built-in server** - serves files from `app/public/` directory

### Database Access
- **Host**: localhost
- **Port**: 5000
- **Username**: root
- **Password**: password
- **Database**: app
- **Initialization**: Files in `database/` directory

## 🐛 Debugging with PhpStorm

### 1. Install xDebug Helper Extension
- **Chrome**: [xDebug Helper](https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
- **Firefox**: [xDebug Helper](https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/)
- **Edge**: [xDebug Helper](https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen)

### 2. Configure xDebug Helper
- Set IDE key to: `PHPSTORM`
- Set Trace Trigger to: `XDEBUG_TRACE`
- Set Profile Trigger to: `XDEBUG_PROFILE`

### 3. Setup PhpStorm
1. Open Settings (`Ctrl+Alt+S`)
2. Go to Build, Execution, Deployment → Docker
3. Add Docker server with name: `Docker`

### 4. Start Debugging
1. Click the bug icon in PhpStorm to start listening
2. Press `Ctrl+Shift+X` in browser and select "debug"
3. Set breakpoints in your PHP code
4. Refresh the page to trigger debugging

## 🚀 Production Deployment

### Build Production Image
```bash
docker-compose -f docker-compose.yml up php-prod --build
```

### Publish to Docker Hub
1. Edit `docker-compose.yml` and update the image name:
   ```yaml
   image: your-dockerid/yourimage
   ```
2. Push the image:
   ```bash
   docker compose push php-prod
   ```

## 🔐 Advanced Configuration

### SSH Keys for Git/Composer
To use private repositories inside the container:

1. Uncomment the `secrets` section in `docker-compose.yml`
2. Ensure your SSH keys are in `~/.ssh/` on your host machine
3. Test connection:
   ```bash
   docker-compose exec php-dev bash
   ssh git@github.com
   ```

### AWS CLI Integration
To use AWS services inside the container:

1. Uncomment the AWS secrets in `docker-compose.yml`
2. Ensure your AWS credentials are in `~/.aws/` on your host machine
3. Uncomment "Install AWS-CLI" in the Dockerfile
4. Test connection:
   ```bash
   docker-compose exec php-dev bash
   aws sts get-caller-identity
   ```

## 🛠️ Common Commands

```bash
# Start development environment
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs php-dev

# Access container shell
docker-compose exec php-dev bash

# Rebuild containers
docker-compose up --build

# Run self-test
./self-test.sh
```

## 🆘 Troubleshooting

### Port Already in Use
If you get port conflicts, edit the ports in `docker-compose.yml`:
```yaml
ports:
  - "8089:80"  # Change 8088 to another port
```

### xDebug Not Working
1. Ensure xDebug Helper extension is installed and configured
2. Check that PhpStorm is listening for connections
3. Verify the IDE key matches in both PhpStorm and browser extension

### Database Connection Issues
1. Ensure MariaDB container is running: `docker-compose ps`
2. Check database logs: `docker-compose logs mariadb`
3. Verify connection string in environment variables

### Application Not Loading
1. Check that the PHP development server is running: `docker-compose logs php-dev`
2. Verify the `app/public/index.php` file exists and is accessible
3. Check file permissions in the `app/` directory

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [xDebug Documentation](https://xdebug.org/docs/)
- [PhpStorm Docker Integration](https://www.jetbrains.com/help/phpstorm/docker.html)
- [Production Hosting Options](https://www.hostingadvice.com/how-to/best-docker-container-hosting/)
- [Database Setup Guide](database/0_README.md)

## 📝 License

This project is a template. Feel free to fork and customize for your own projects.

---

**Video Tutorial**: [PHP Docker Quickstart Setup](https://youtu.be/hpBOagsSF_E)

