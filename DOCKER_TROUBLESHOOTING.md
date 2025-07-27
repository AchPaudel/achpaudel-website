# Docker Troubleshooting Guide

This guide helps resolve common Docker build and deployment issues for the Achyut Dev Site project.

## 🚨 Common Issues and Solutions

### 1. Missing nginx.conf File

**Error:**
```
failed to solve: failed to compute cache key: failed to calculate checksum of ref 355cea5c-84dd-4610-ac7c-12528b073c48::u7xoy1x5q1dhzu0whxeto2ku0: "/nginx.conf": not found
```

**Solution:**
The `nginx.conf` file is now created in the `frontend/` directory. This file configures nginx for serving the Angular application.

### 2. Docker Not Installed

**Error:**
```
zsh: command not found: docker
```

**Solution:**
Install Docker Desktop for macOS:
```bash
# Download from official website
https://www.docker.com/products/docker-desktop/

# Or install via Homebrew
brew install --cask docker
```

### 3. Docker Compose Not Installed

**Error:**
```
zsh: command not found: docker-compose
```

**Solution:**
Docker Compose is included with Docker Desktop. If you need it separately:
```bash
# Install via Homebrew
brew install docker-compose

# Or install via pip
pip install docker-compose
```

### 4. Port Conflicts

**Error:**
```
Error response from daemon: driver failed programming external connectivity on endpoint: Bind for 0.0.0.0:8080 failed: port is already allocated
```

**Solution:**
- Check what's using the port: `lsof -i :8080`
- Stop conflicting services
- Or change the port in `docker-compose.yml`

### 5. Build Context Issues

**Error:**
```
failed to compute cache key: failed to calculate checksum
```

**Solution:**
- Ensure all required files exist in the build context
- Check file permissions
- Clean Docker cache: `docker system prune -a`

## 🔧 Build Process

### Frontend Build

The frontend build process:
1. Uses Node.js 18 Alpine image
2. Installs dependencies with `npm ci --only=production`
3. Builds Angular app with `npm run build`
4. Serves with nginx

### Backend Build

The backend build process:
1. Uses OpenJDK 17 slim image
2. Uses Maven wrapper for building
3. Creates non-root user for security
4. Exposes port 8080

## 📋 Pre-Build Checklist

Before running Docker builds, ensure:

### ✅ Files Exist
```bash
# Check required files
ls -la frontend/nginx.conf
ls -la frontend/package.json
ls -la frontend/angular.json
ls -la backend/pom.xml
ls -la backend/mvnw
ls -la docker/nginx/nginx.conf
```

### ✅ Dependencies
```bash
# Check Docker installation
docker --version
docker-compose --version

# Check available ports
lsof -i :8080
lsof -i :8081
lsof -i :4200
lsof -i :5432
```

### ✅ Permissions
```bash
# Make scripts executable
chmod +x backend/mvnw
chmod +x scripts/*.sh
```

## 🚀 Build Commands

### Individual Services
```bash
# Build frontend only
cd docker
docker-compose build frontend

# Build backend only
docker-compose build backend

# Build database only
docker-compose build db
```

### All Services
```bash
# Build all services
cd docker
docker-compose build

# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Development Build
```bash
# Build with no cache (force rebuild)
docker-compose build --no-cache

# Build specific service with no cache
docker-compose build --no-cache frontend
```

## 🔍 Debugging Commands

### Check Container Status
```bash
# List all containers
docker ps -a

# Check container logs
docker logs achpaudel-frontend
docker logs achpaudel-backend
docker logs achpaudel-db
```

### Check Network
```bash
# List networks
docker network ls

# Inspect network
docker network inspect achpaudel-website_achpaudel-network
```

### Check Volumes
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect achpaudel-website_postgres_data
```

## 🛠️ Manual Build Steps

If Docker build fails, you can build manually:

### Frontend Manual Build
```bash
cd frontend

# Install dependencies
npm install

# Build for production
npm run build

# Test the build
npx serve dist/achpaudel-website
```

### Backend Manual Build
```bash
cd backend

# Install Java 17 first
./scripts/install-java17.sh

# Build with Maven
./mvnw clean package -DskipTests

# Run the application
./mvnw spring-boot:run
```

## 🔧 Configuration Files

### Frontend nginx.conf
- Handles Angular routing with `try_files`
- Configures caching for static assets
- Sets security headers
- Proxies API requests to backend

### Docker Compose
- Maps ports correctly
- Sets up networking
- Configures environment variables
- Manages volumes and dependencies

## 🚨 Common Fixes

### 1. Clear Docker Cache
```bash
# Remove all unused containers, networks, images
docker system prune -a

# Remove specific images
docker rmi $(docker images -q)
```

### 2. Fix File Permissions
```bash
# Make scripts executable
chmod +x backend/mvnw
chmod +x scripts/*.sh

# Fix nginx config permissions
chmod 644 frontend/nginx.conf
```

### 3. Update Dependencies
```bash
# Update npm packages
cd frontend
npm update

# Update Maven dependencies
cd backend
./mvnw dependency:resolve
```

### 4. Check Disk Space
```bash
# Check available disk space
df -h

# Clean Docker system
docker system prune -a --volumes
```

## 📊 Monitoring

### Health Checks
```bash
# Frontend health
curl http://localhost:4200/health

# Backend health
curl http://localhost:8081/api/actuator/health

# Database health
docker exec achpaudel-db pg_isready -U postgres
```

### Resource Usage
```bash
# Check container resource usage
docker stats

# Check disk usage
docker system df
```

## 🆘 Getting Help

If you're still experiencing issues:

1. **Check the logs**: `docker-compose logs -f`
2. **Verify file structure**: Ensure all required files exist
3. **Check permissions**: Make sure scripts are executable
4. **Clear cache**: Remove Docker cache and rebuild
5. **Check ports**: Ensure no port conflicts
6. **Update Docker**: Make sure you have the latest Docker version

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Angular Build Documentation](https://angular.io/guide/build)

---

**Happy Dockerizing! 🐳**

Remember: Docker builds can be complex, but following this guide should resolve most common issues. 