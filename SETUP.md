# Detailed Setup Guide

This guide provides step-by-step instructions for setting up the PHP Docker Quickstart project.

## Prerequisites Installation

### 1. Install Docker Desktop

**Windows:**
1. Download Docker Desktop from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Run the installer and follow the setup wizard
3. Restart your computer when prompted
4. Start Docker Desktop from the Start menu

**macOS:**
1. Download Docker Desktop from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Drag Docker to Applications folder
3. Start Docker Desktop from Applications
4. Grant necessary permissions when prompted

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo usermod -aG docker $USER
# Log out and back in
```

### 2. Install PhpStorm (Optional)

1. Download PhpStorm from [https://www.jetbrains.com/phpstorm/](https://www.jetbrains.com/phpstorm/)
2. Install and activate with your license or trial
3. Install Docker integration plugin if not included

## Project Setup

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd php-docker-quickstart
```

### 2. Start the Development Environment

```bash
# Start all services in the background
docker-compose up -d

# Or start with logs visible
docker-compose up
```

### 3. Verify Installation

1. Open your browser and go to http://localhost:8088
2. You should see the PHP info page
3. Check PhpMyAdmin at http://localhost:7088
4. Verify database connection with credentials:
   - Host: localhost
   - Port: 5000
   - Username: root
   - Password: password

## PhpStorm Configuration

### 1. Configure Docker Integration

1. Open PhpStorm
2. Go to File → Settings (Ctrl+Alt+S)
3. Navigate to Build, Execution, Deployment → Docker
4. Click the + button and select Docker
5. Name it "Docker" and click OK

### 2. Configure xDebug

1. Install xDebug Helper browser extension:
   - [Chrome](https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
   - [Firefox](https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/)
   - [Edge](https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen)

2. Configure the extension:
   - Right-click the extension icon
   - Go to Extension Options
   - Set IDE key to: `PHPSTORM`
   - Set Trace Trigger to: `XDEBUG_TRACE`
   - Set Profile Trigger to: `XDEBUG_PROFILE`

### 3. Test Debugging

1. In PhpStorm, click the bug icon to start listening
2. Open http://localhost:8088 in your browser
3. Press Ctrl+Shift+X and select "debug"
4. Set a breakpoint in your PHP code
5. Refresh the page - PhpStorm should stop at the breakpoint

## Development Workflow

### 1. Making Changes

1. Edit files in the `app/html/` directory
2. Changes are immediately reflected at http://localhost:8088
3. No need to restart containers for code changes

### 2. Database Development

1. Access PhpMyAdmin at http://localhost:7088
2. Use external tools like MySQL Workbench with:
   - Host: localhost
   - Port: 5000
   - Username: root
   - Password: password
3. Database initialization scripts are in `database/` directory
4. See `database/0_README.md` for database setup documentation

### 3. Container Management

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs php-dev

# Access container shell
docker-compose exec php-dev bash

# Stop all services
docker-compose down

# Rebuild containers
docker-compose up --build
```

## Troubleshooting

### Common Issues

**Docker not running:**
- Ensure Docker Desktop is started
- Check Docker service status

**Port conflicts:**
- Edit `docker-compose.yml` and change port mappings
- Example: Change `8088:80` to `8089:80`

**xDebug not working:**
- Verify browser extension is installed and configured
- Check PhpStorm is listening for connections
- Ensure IDE key matches in both PhpStorm and extension

**Database connection failed:**
- Check if MariaDB container is running: `docker-compose ps`
- View database logs: `docker-compose logs mariadb`
- Verify connection string in environment variables

### Getting Help

1. Check the main README.md for quick reference
2. Review Docker and PhpStorm documentation
3. Check container logs for error messages
4. Verify all prerequisites are properly installed 