# Achyut Paudel - Personal Website

A modern personal website built with Angular 18 frontend and Spring Boot 3.2.x backend, designed to be deployed on DreamCompute with SSL support.

## 🚀 Features

- **Frontend**: Angular 18 with modern UI/UX
- **Backend**: Spring Boot 3.2.x REST API
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx with SSL support
- **Domain**: achpaudel.dev
- **API Endpoints**: `/api/*` for backend communication
- **Frontend Routes**: `/home` as default route

## 🏗️ Architecture

```
achpaudel-website/
├── client/                 # Angular frontend
│   ├── src/app/
│   │   ├── components/     # Angular components
│   │   ├── services/       # API services
│   │   └── home/          # Home page component
│   └── src/assets/
├── server/                 # Spring Boot backend
│   ├── src/main/java/
│   │   └── com/achpaudel/website/
│   │       ├── controller/ # REST controllers
│   │       ├── service/    # Business logic
│   │       ├── model/      # Data models
│   │       └── config/     # Configuration
│   └── src/main/resources/
├── nginx/                  # Nginx configuration
│   ├── nginx.conf
│   └── conf.d/
├── ssl/                    # SSL certificates
└── docker-compose.yml      # Docker orchestration
```

## 🛠️ Tech Stack

### Frontend
- **Framework**: Angular 18
- **Language**: TypeScript
- **Styling**: CSS with modern design
- **Build Tool**: Angular CLI

### Backend
- **Framework**: Spring Boot 3.2.x
- **Language**: Java 17
- **HTTP Client**: WebFlux for external API calls
- **Documentation**: OpenAPI 3 (Swagger)
- **Build Tool**: Maven

### DevOps
- **Containerization**: Docker & Docker Compose
- **Reverse Proxy**: Nginx
- **SSL**: Let's Encrypt (manual setup)
- **Hosting**: DreamCompute

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git
- DreamCompute instance (for production)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd achpaudel-website
   ```

2. **Start with Docker Compose**
   ```bash
   docker-compose up -d
   ```

3. **Access the applications**
   - Frontend: http://localhost
   - Backend API: http://localhost/api
   - Swagger UI: http://localhost/api/swagger-ui.html

### Manual Development

#### Backend
```bash
cd server
./mvnw spring-boot:run
```

#### Frontend
```bash
cd client
npm install
ng serve
```

## 📦 Deployment

### DreamCompute Setup

1. **Create DreamCompute Instance**
   - Choose Ubuntu 22.04 LTS
   - Minimum 2GB RAM, 1 vCPU
   - 20GB storage

2. **Install Dependencies**
   ```bash
   sudo apt update
   sudo apt install -y docker.io docker-compose git
   sudo usermod -aG docker $USER
   ```

3. **Clone and Deploy**
   ```bash
   git clone <your-repo-url>
   cd achpaudel-website
   docker-compose up -d
   ```

### SSL Certificate Setup

1. **Generate SSL Certificate**
   ```bash
   # Create SSL directory
   mkdir -p ssl
   
   # Generate self-signed certificate (for testing)
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
     -keyout ssl/achpaudel.dev.key \
     -out ssl/achpaudel.dev.crt \
     -subj "/C=US/ST=State/L=City/O=Organization/CN=achpaudel.dev"
   ```

2. **For Production (Let's Encrypt)**
   ```bash
   # Install certbot
   sudo apt install certbot
   
   # Get certificate
   sudo certbot certonly --standalone -d achpaudel.dev -d www.achpaudel.dev
   
   # Copy certificates
   sudo cp /etc/letsencrypt/live/achpaudel.dev/fullchain.pem ssl/achpaudel.dev.crt
   sudo cp /etc/letsencrypt/live/achpaudel.dev/privkey.pem ssl/achpaudel.dev.key
   ```

## 🔧 Configuration

### Environment Variables

Create `.env` file in the root directory:
```bash
# Backend
SPRING_PROFILES_ACTIVE=production
SERVER_PORT=8080

# Frontend
API_BASE_URL=https://achpaudel.dev/api
```

### Domain Configuration

1. **DNS Settings**
   - Point `achpaudel.dev` to your DreamCompute IP
   - Point `www.achpaudel.dev` to your DreamCompute IP

2. **Firewall Rules**
   ```bash
   # Allow HTTP, HTTPS, and SSH
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw allow 22/tcp
   sudo ufw enable
   ```

## 📚 API Documentation

### Available Endpoints

- `GET /api/health` - Health check
- `GET /api/info` - API information
- `GET /api/external/{service}` - External API proxy
- `GET /api/data` - Get all data (CRUD example)
- `POST /api/data` - Create data
- `PUT /api/data/{id}` - Update data
- `DELETE /api/data/{id}` - Delete data

### External API Services

- `microsoft-graph` - Microsoft Graph API
- `github` - GitHub API
- `weather` - OpenWeatherMap API
- `news` - News API

### Example API Calls

```bash
# Health check
curl https://achpaudel.dev/api/health

# Get API info
curl https://achpaudel.dev/api/info

# Call external API
curl "https://achpaudel.dev/api/external/github?endpoint=/users/octocat"
```

## 🧪 Testing

### Backend Tests
```bash
cd server
./mvnw test
```

### Frontend Tests
```bash
cd client
ng test
```

### Integration Tests
```bash
# Test the full stack
docker-compose up -d
curl http://localhost/api/health
```

## 🔒 Security

- HTTPS enforcement
- CORS configuration
- Rate limiting
- Security headers
- Input validation
- XSS protection

## 📊 Monitoring

- Nginx access/error logs
- Spring Boot application logs
- Docker container logs
- Health check endpoints

## 🚀 Development Workflow

1. **Local Development**
   ```bash
   docker-compose up -d
   # Make changes to code
   docker-compose restart
   ```

2. **Testing Changes**
   ```bash
   # Test backend
   curl http://localhost/api/health
   
   # Test frontend
   open http://localhost
   ```

3. **Deployment**
   ```bash
   # On DreamCompute server
   git pull
   docker-compose down
   docker-compose up -d --build
   ```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 📞 Contact

- **Website**: https://achpaudel.dev
- **Email**: [your-email@example.com]
- **GitHub**: [your-github-username]

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- Angular team for the powerful frontend framework
- Docker team for containerization
- DreamHost for reliable hosting 