# Quick Start Guide - Achyut Dev Site

This guide will help you get the Achyut Dev Site up and running quickly, whether for development or production deployment.

## 🚀 Prerequisites

Before starting, ensure you have the following installed:

- **Java 17** (OpenJDK or Oracle JDK)
- **Node.js 18+** and npm
- **Docker & Docker Compose**
- **Git**
- **PostgreSQL 15** (for production)

### Verify Installation

```bash
# Check Java version
java -version

# Check Node.js version
node --version
npm --version

# Check Docker
docker --version
docker-compose --version

# Check Git
git --version
```

## 📦 Project Setup

### 1. Clone and Navigate

```bash
git clone https://github.com/yourusername/achpaudel-website.git
cd achpaudel-website
```

### 2. Environment Configuration

Create environment-specific configuration files:

```bash
# Create .env file for local development
cp .env.example .env
```

Edit `.env` with your local settings:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=achpaudel_website
DB_USER=postgres
DB_PASSWORD=your_secure_password

# Backend
SPRING_PROFILES_ACTIVE=dev
JWT_SECRET=your-secret-key-here-make-it-very-long-and-secure

# Frontend
API_BASE_URL=http://localhost:8080/api
```

## 🏗️ Backend Setup

### 1. Build the Backend

```bash
cd backend

# Clean and build
./mvnw clean install

# Run with Maven
./mvnw spring-boot:run
```

### 2. Verify Backend

The backend will start on `http://localhost:8080` with:
- API endpoints: `http://localhost:8080/api`
- Swagger UI: `http://localhost:8080/swagger-ui.html`
- H2 Console: `http://localhost:8080/h2-console` (dev profile)

### 3. Test API Endpoints

```bash
# Get all projects
curl http://localhost:8080/api/projects

# Create a test project
curl -X POST http://localhost:8080/api/projects \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Project",
    "description": "A test project for development",
    "technologies": "Spring Boot, Angular, Docker",
    "githubUrl": "https://github.com/test/project",
    "liveUrl": "https://test-project.com",
    "featured": true
  }'
```

## 🎨 Frontend Setup

### 1. Install Dependencies

```bash
cd frontend

# Install dependencies
npm install

# Install Angular CLI globally (if not already installed)
npm install -g @angular/cli
```

### 2. Configure Environment

Create `src/environments/environment.ts`:

```typescript
export const environment = {
  production: false,
  apiBaseUrl: 'http://localhost:8080/api'
};
```

### 3. Start Development Server

```bash
# Start Angular dev server
ng serve

# Or with specific port
ng serve --port 4200
```

The frontend will be available at `http://localhost:4200`

## 🐳 Docker Setup (Recommended)

### 1. Quick Start with Docker Compose

```bash
cd docker

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 2. Access Services

- **Frontend**: http://localhost:4201
- **Backend API**: http://localhost:8081
- **Jenkins**: http://localhost:8082
- **Database**: localhost:5432
- **Nginx**: http://localhost:80

### 3. Database Initialization

The PostgreSQL database will be automatically initialized with sample data. You can also manually initialize:

```bash
# Connect to database container
docker exec -it achpaudel-db psql -U postgres -d achpaudel_website

# Or run initialization script
docker exec -it achpaudel-db psql -U postgres -d achpaudel_website -f /docker-entrypoint-initdb.d/init-db.sql
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
./mvnw test

# Run specific test
./mvnw test -Dtest=ProjectControllerTest

# Run with coverage
./mvnw jacoco:report
```

### Frontend Tests

```bash
cd frontend

# Unit tests
ng test

# E2E tests
ng e2e

# Build for production
ng build --prod
```

## 🔧 Development Workflow

### 1. Backend Development

```bash
cd backend

# Start with hot reload
./mvnw spring-boot:run

# Or with specific profile
./mvnw spring-boot:run -Dspring.profiles.active=dev
```

### 2. Frontend Development

```bash
cd frontend

# Start with hot reload
ng serve

# Build for production
ng build --prod

# Serve production build
ng serve --prod
```

### 3. Database Management

```bash
# Using H2 (dev profile)
# Access: http://localhost:8080/h2-console
# JDBC URL: jdbc:h2:mem:testdb
# Username: sa
# Password: (empty)

# Using PostgreSQL
psql -h localhost -p 5432 -U postgres -d achpaudel_website
```

## 🚀 Production Deployment

### 1. Environment Setup

```bash
# Set production environment
export SPRING_PROFILES_ACTIVE=production
export DB_PASSWORD=your_secure_production_password
```

### 2. Build for Production

```bash
# Backend
cd backend
./mvnw clean package -DskipTests

# Frontend
cd frontend
ng build --prod
```

### 3. Docker Production Build

```bash
cd docker

# Build production images
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

## 🔒 Security Configuration

### 1. JWT Configuration

Update `backend/src/main/resources/application.yml`:

```yaml
jwt:
  secret: your-very-long-and-secure-secret-key-here
  expiration: 86400000 # 24 hours
```

### 2. CORS Configuration

The backend is configured with CORS for development. For production, update the allowed origins in `ProjectController.java`.

### 3. Database Security

```sql
-- Create dedicated user
CREATE USER achpaudel_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE achpaudel_website TO achpaudel_user;
```

## 📊 Monitoring & Logs

### 1. Application Logs

```bash
# Backend logs
docker logs achpaudel-backend

# Frontend logs
docker logs achpaudel-frontend

# All services
docker-compose logs -f
```

### 2. Health Checks

```bash
# Backend health
curl http://localhost:8080/api/actuator/health

# Database connection
docker exec -it achpaudel-db pg_isready -U postgres
```

## 🐛 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   # Check what's using the port
   lsof -i :8080
   lsof -i :4200
   ```

2. **Database Connection Issues**
   ```bash
   # Check if PostgreSQL is running
   docker ps | grep postgres
   
   # Restart database
   docker-compose restart db
   ```

3. **Build Issues**
   ```bash
   # Clean and rebuild
   ./mvnw clean install
   npm install
   ```

4. **Docker Issues**
   ```bash
   # Remove all containers and volumes
   docker-compose down -v
   docker system prune -a
   ```

### Getting Help

- Check the logs: `docker-compose logs -f`
- Verify environment variables
- Ensure all prerequisites are installed
- Check network connectivity

## 📚 Next Steps

1. **Customize Content**: Update project data and personal information
2. **Add Features**: Implement authentication, blog functionality, contact forms
3. **Deploy**: Follow the DreamCompute setup guide in `docs/dreamcompute-setup.md`
4. **Monitor**: Set up monitoring and alerting
5. **Scale**: Configure load balancing and caching

## 🔗 Useful Commands

```bash
# Quick status check
docker-compose ps

# View real-time logs
docker-compose logs -f backend

# Restart specific service
docker-compose restart frontend

# Access container shell
docker exec -it achpaudel-backend /bin/bash

# Database backup
docker exec achpaudel-db pg_dump -U postgres achpaudel_website > backup.sql
```

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review the logs: `docker-compose logs -f`
3. Verify your environment setup
4. Check the [GitHub Issues](https://github.com/yourusername/achpaudel-website/issues)

---

**Happy Coding! 🚀**

Your Achyut Dev Site should now be running successfully. You can start customizing the content and adding new features to make it your own. 