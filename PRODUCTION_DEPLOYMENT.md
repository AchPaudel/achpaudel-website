# Production Deployment Guide

This guide covers deploying the achpaudel.dev application to production.

## 🚀 Quick Start

### 1. Prerequisites

- Docker and Docker Compose installed
- Domain name (achpaudel.dev) pointing to your server
- Server with at least 2GB RAM and 20GB storage
- Ubuntu 20.04+ or similar Linux distribution

### 2. Server Setup

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
```

### 3. Application Deployment

```bash
# Clone repository
git clone <your-repo-url>
cd achpaudel-website

# Copy environment template
cp env.production.template .env

# Edit environment variables
nano .env

# Deploy to production
./scripts/deploy-production.sh
```

## 🔧 Configuration

### Environment Variables (.env)

```bash
# Database Configuration
POSTGRES_DB=achpaudel_website
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password_here

# Spring Boot Configuration
SPRING_SECURITY_USER_NAME=admin
SPRING_SECURITY_USER_PASSWORD=your_admin_password_here

# Logging Levels
LOGGING_LEVEL_COM_ACHPUDEL_WEBSITE=INFO
LOGGING_LEVEL_ORG_SPRINGFRAMEWORK_SECURITY=WARN
LOGGING_LEVEL_ORG_HIBERNATE_SQL=WARN

# Domain Configuration
DOMAIN=achpaudel.dev
```

### SSL Certificate Setup

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d achpaudel.dev -d www.achpaudel.dev

# Copy SSL files to Docker
sudo cp /etc/letsencrypt/live/achpaudel.dev/fullchain.pem docker/ssl/achpaudel.dev.crt
sudo cp /etc/letsencrypt/live/achpaudel.dev/privkey.pem docker/ssl/achpaudel.dev.key

# Set proper permissions
sudo chown -R $USER:$USER docker/ssl/
chmod 600 docker/ssl/*.key
chmod 644 docker/ssl/*.crt
```

## 📊 Monitoring

### Health Checks

- **Main Site**: `http://achpaudel.dev/health`
- **API**: `http://achpaudel.dev/api/health`
- **Database**: `docker exec achpaudel-db pg_isready`

### Logs

```bash
# View all logs
docker compose -f docker/docker-compose.prod.yml logs -f

# View specific service logs
docker compose -f docker/docker-compose.prod.yml logs -f backend
docker compose -f docker/docker-compose.prod.yml logs -f frontend
docker compose -f docker/docker-compose.prod.yml logs -f nginx
```

### Performance Monitoring

```bash
# Check resource usage
docker stats

# Check disk usage
df -h

# Check memory usage
free -h
```

## 🔒 Security

### Firewall Configuration

```bash
# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
```

### Database Security

- Use strong passwords
- Restrict database access to application only
- Regular backups
- Monitor for suspicious activity

### Application Security

- HTTPS only in production
- Security headers enabled
- Rate limiting configured
- Input validation
- SQL injection prevention

## 🔄 Maintenance

### Regular Updates

```bash
# Update application
git pull origin main
./scripts/deploy-production.sh

# Update SSL certificate (auto-renewal)
sudo certbot renew --dry-run
```

### Backups

```bash
# Database backup
docker exec achpaudel-db pg_dump -U postgres achpaudel_website > backup.sql

# Volume backup
docker run --rm -v achpaudel-website_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

### Troubleshooting

#### Common Issues

1. **Port conflicts**
   ```bash
   # Check what's using the port
   sudo lsof -i :80
   sudo lsof -i :443
   ```

2. **SSL certificate issues**
   ```bash
   # Test nginx configuration
   docker exec achpaudel-nginx nginx -t
   
   # Check SSL certificate
   openssl x509 -in docker/ssl/achpaudel.dev.crt -text -noout
   ```

3. **Database connection issues**
   ```bash
   # Check database status
   docker exec achpaudel-db pg_isready
   
   # Check application logs
   docker compose -f docker/docker-compose.prod.yml logs backend
   ```

#### Performance Issues

1. **High memory usage**
   - Check Redis memory usage
   - Monitor database connections
   - Review application logs

2. **Slow response times**
   - Check nginx access logs
   - Monitor database performance
   - Review caching configuration

## 📈 Scaling

### Horizontal Scaling

```bash
# Scale backend services
docker compose -f docker/docker-compose.prod.yml up -d --scale backend=3

# Load balancer configuration
# Add nginx upstream configuration for multiple backend instances
```

### Vertical Scaling

- Increase server resources
- Optimize database queries
- Implement caching strategies
- Use CDN for static assets

## 🚨 Emergency Procedures

### Service Recovery

```bash
# Restart all services
docker compose -f docker/docker-compose.prod.yml restart

# Restart specific service
docker compose -f docker/docker-compose.prod.yml restart backend

# Check service health
docker compose -f docker/docker-compose.prod.yml ps
```

### Rollback Procedure

```bash
# Rollback to previous version
git checkout <previous-commit>
./scripts/deploy-production.sh
```

## 📞 Support

For issues and questions:
- Check logs first
- Review this documentation
- Check GitHub issues
- Contact system administrator

---

**Last Updated**: $(date)
**Version**: 1.0.0 