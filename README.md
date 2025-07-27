# Achyut Dev Site

Personal website and portfolio built with Spring Boot REST API backend and Angular frontend, containerized with Docker and deployed via Jenkins CI/CD.

## 🚀 Features

- **Backend**: Spring Boot 3.2.0 with Java 17
- **Frontend**: Angular 18 with modern UI/UX
- **Database**: PostgreSQL with JPA/Hibernate
- **Containerization**: Docker & Docker Compose
- **CI/CD**: Jenkins pipeline for automated deployments
- **Hosting**: DreamCompute cloud infrastructure
- **Domain**: achpaudel.dev

## 🏗️ Architecture

```
achpaudel-website/
├── backend/                 # Spring Boot REST API
│   ├── src/main/java/
│   │   └── com/achpaudel/website/
│   │       ├── controller/  # REST controllers
│   │       ├── service/     # Business logic
│   │       ├── repository/  # Data access layer
│   │       ├── model/       # Entity models
│   │       └── config/      # Configuration classes
│   └── src/main/resources/
├── frontend/                # Angular application
│   ├── src/app/
│   │   ├── components/      # Reusable components
│   │   ├── services/        # API services
│   │   ├── models/          # TypeScript interfaces
│   │   └── pages/           # Page components
│   └── src/assets/
├── docker/                  # Docker configuration
│   ├── docker-compose.yml   # Multi-container setup
│   └── nginx/              # Reverse proxy config
├── jenkins/                 # CI/CD pipeline
└── docs/                   # Documentation
```

## 🛠️ Tech Stack

### Backend
- **Framework**: Spring Boot 3.2.0
- **Language**: Java 17
- **Database**: PostgreSQL 15
- **ORM**: Spring Data JPA
- **Security**: Spring Security + JWT
- **Documentation**: OpenAPI 3 (Swagger)
- **Build Tool**: Maven

### Frontend
- **Framework**: Angular 18
- **Language**: TypeScript
- **Styling**: Angular Material + Tailwind CSS
- **State Management**: NgRx (optional)
- **Build Tool**: Angular CLI

### DevOps
- **Containerization**: Docker & Docker Compose
- **CI/CD**: Jenkins
- **Reverse Proxy**: Nginx
- **SSL**: Let's Encrypt
- **Monitoring**: Prometheus + Grafana (planned)

## 🚀 Quick Start

For detailed setup instructions, see the [Quick Start Guide](QUICK_START.md).

### Prerequisites
- Java 17
- Node.js 18+
- Docker & Docker Compose
- Git

### Quick Setup with Docker

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/achpaudel-website.git
   cd achpaudel-website
   ```

2. **Start with Docker Compose**
   ```bash
   cd docker
   docker-compose up -d
   ```

3. **Access the applications**
   - Frontend: http://localhost:4200
   - Backend API: http://localhost:8081
   - Jenkins: http://localhost:8080
   - Database: localhost:5432

### Manual Setup

#### Backend
```bash
cd backend
./mvnw clean install
./mvnw spring-boot:run
```

#### Frontend
```bash
cd frontend
npm install
ng serve
```

## 📦 Deployment

### DreamCompute Setup
Follow the detailed setup guide in `docs/dreamcompute-setup.md`

### Key Steps:
1. Create DreamCompute instance
2. Install Docker, Java, Node.js
3. Configure Nginx reverse proxy
4. Set up SSL certificates
5. Deploy with Jenkins pipeline

## 🔧 Configuration

### Environment Variables
Create `.env` files for different environments:

```bash
# Backend
SPRING_PROFILES_ACTIVE=production
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/achpaudel_website
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=your_secure_password

# Frontend
API_BASE_URL=https://api.achpaudel.dev
```

### Database Setup
```sql
CREATE DATABASE achpaudel_website;
CREATE USER achpaudel_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE achpaudel_website TO achpaudel_user;
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
./mvnw test
```

### Frontend Tests
```bash
cd frontend
ng test
ng e2e
```

## 📚 API Documentation

Once the backend is running, access the API documentation at:
- Swagger UI: http://localhost:8081/swagger-ui.html
- OpenAPI JSON: http://localhost:8081/api-docs

## 🔒 Security

- JWT-based authentication
- CORS configuration
- Input validation
- SQL injection prevention
- XSS protection
- HTTPS enforcement

## 📊 Monitoring

- Application metrics with Micrometer
- Health checks
- Log aggregation
- Performance monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Website**: https://achpaudel.dev
- **Email**: [your-email@example.com]
- **GitHub**: [your-github-username]

## 🙏 Acknowledgments

- Spring Boot team for the excellent framework
- Angular team for the powerful frontend framework
- Docker team for containerization
- DreamHost for reliable hosting 