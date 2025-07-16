# Quick Reference

## 🚀 Essential Commands

```bash
# Start development environment
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs php-dev

# Rebuild containers
docker-compose up --build

# Access container shell
docker-compose exec php-dev bash
```

## 🌐 Access URLs

| Service     | URL                   | Description          |
|-------------|-----------------------|----------------------|
| Development | http://localhost:8088 | Your PHP application |
| Production  | http://localhost:9088 | Production build     |
| PhpMyAdmin  | http://localhost:7088 | Database management  |

## 🗄️ Database Connection

```
Host: localhost
Port: 5000
Username: root
Password: password
Database: app
```

## 🐛 Debugging Setup

### Browser Extension
- **Chrome**: [xDebug Helper](https://chromewebstore.google.com/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
- **Firefox**: [xDebug Helper](https://addons.mozilla.org/en-US/firefox/addon/xdebug-helper-for-firefox/)
- **Edge**: [xDebug Helper](https://microsoftedge.microsoft.com/addons/detail/xdebug-helper/ggnngifabofaddiejjeagbaebkejomen)

### Extension Settings
- IDE Key: `PHPSTORM`
- Trace Trigger: `XDEBUG_TRACE`
- Profile Trigger: `XDEBUG_PROFILE`

### Debug Workflow
1. Click bug icon in PhpStorm
2. Press `Ctrl+Shift+X` in browser
3. Select "debug"
4. Set breakpoints and refresh

## 🔧 Common Customizations

### Change Ports
Edit `docker-compose.yml`:
```yaml
ports:
  - "8089:80"  # Change 8088 to desired port
```

### Add PHP Extensions
Edit the `Dockerfile` and add extensions to the appropriate target:
```dockerfile
RUN docker-php-ext-install pdo_mysql mysqli
```

### Add Environment Variables
Edit `docker-compose.yml`:
```yaml
environment:
  - MY_VAR=value
```

## 🆘 Troubleshooting

### Port Already in Use
```bash
# Check what's using the port
netstat -ano | findstr :8088

# Change port in docker-compose.yml
```

### Container Won't Start
```bash
# Check logs
docker-compose logs php-dev

# Rebuild from scratch
docker-compose down
docker-compose up --build
```

### xDebug Not Working
1. Verify extension is installed and configured
2. Check PhpStorm is listening
3. Ensure IDE key matches
4. Restart containers: `docker-compose restart`

## 📁 Project Structure

```
php-docker-quickstart/
├── app/html/              # Your PHP files here
├── config/docker/         # Docker configs
├── database/              # Database initialization
├── Startup-Database/      # Legacy database directory
├── xdebug.info/          # xDebug profiling output
├── docker-compose.yml     # Main config
├── Dockerfile            # Docker image definition
├── README.md             # Main documentation
├── SETUP.md              # Detailed setup
├── CONTRIBUTING.md       # How to contribute
└── QUICK_REFERENCE.md    # This file
```

## 🔐 Advanced Features

### SSH Keys for Git
1. Uncomment `secrets` in `docker-compose.yml`
2. Ensure SSH keys in `~/.ssh/`
3. Test: `docker-compose exec php-dev ssh git@github.com`

### AWS CLI
1. Uncomment AWS secrets in `docker-compose.yml`
2. Ensure AWS credentials in `~/.aws/`
3. Test: `docker-compose exec php-dev aws sts get-caller-identity`

## 📞 Getting Help

- **Main Guide**: README.md
- **Setup Issues**: SETUP.md
- **Customization**: CONTRIBUTING.md
- **Database Setup**: database/0_README.md
- **Video Tutorial**: [PHP Docker Quickstart](https://youtu.be/hpBOagsSF_E) 