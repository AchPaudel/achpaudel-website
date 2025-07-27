#!/bin/bash

# Production Deployment Script for achpaudel.dev
# This script deploys the application with production configuration

set -e

echo "🚀 Deploying achpaudel.dev to production..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the project root
if [ ! -f "README.md" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    print_warning "No .env file found. Creating from template..."
    cp env.production.template .env
    print_warning "Please edit .env file with your production values before continuing"
    exit 1
fi

# Load environment variables
print_status "Loading environment variables..."
source .env

# Check required environment variables
required_vars=("POSTGRES_PASSWORD" "SPRING_SECURITY_USER_PASSWORD")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ] || [ "${!var}" = "your_secure_password_here" ] || [ "${!var}" = "your_admin_password_here" ]; then
        print_error "Please set $var in your .env file"
        exit 1
    fi
done

print_status "Environment variables validated"

# Check if docker-compose.prod.yml exists
if [ ! -f "docker/docker-compose.prod.yml" ]; then
    print_error "docker-compose.prod.yml not found in docker directory"
    exit 1
fi

# Create SSL directory if it doesn't exist
mkdir -p docker/ssl

print_status "Stopping all existing containers..."
cd docker
docker compose -f docker-compose.prod.yml down

print_status "Building all services with production configuration..."
docker compose -f docker-compose.prod.yml build --no-cache

print_status "Starting database..."
docker compose -f docker-compose.prod.yml up -d db
sleep 15

print_status "Starting backend..."
docker compose -f docker-compose.prod.yml up -d backend
sleep 20

print_status "Starting frontend..."
docker compose -f docker-compose.prod.yml up -d frontend
sleep 15

print_status "Starting Redis..."
docker compose -f docker-compose.prod.yml up -d redis
sleep 10

print_status "Starting nginx..."
docker compose -f docker-compose.prod.yml up -d nginx
sleep 10

# Check all services
print_status "Checking service status..."
docker compose -f docker-compose.prod.yml ps

# Test endpoints
print_status "Testing production endpoints..."

# Test main site
if curl -s http://localhost > /dev/null 2>&1; then
    print_success "✅ Main site (achpaudel.dev) is accessible"
else
    print_warning "⚠️  Main site not responding yet"
fi

# Test API
if curl -s http://localhost:8080/api/health > /dev/null 2>&1; then
    print_success "✅ API is accessible"
else
    print_warning "⚠️  API not responding yet"
fi

# Test frontend directly
if curl -s http://localhost > /dev/null 2>&1; then
    print_success "✅ Frontend is accessible"
else
    print_warning "⚠️  Frontend not responding yet"
fi

print_success "Production deployment complete!"
echo ""
echo "🌐 Production URLs:"
echo "  - Main site: http://achpaudel.dev"
echo "  - API: http://achpaudel.dev/api"
echo "  - Database: localhost:5432"
echo "  - Redis: localhost:6379"
echo ""
echo "🔧 SSL Setup (Required for production):"
echo "  1. Install Certbot: sudo apt install certbot python3-certbot-nginx"
echo "  2. Get SSL certificate: sudo certbot --nginx -d achpaudel.dev -d www.achpaudel.dev"
echo "  3. Copy SSL files to docker/ssl/ directory"
echo "  4. Update nginx config to use SSL"
echo ""
echo "🔍 Useful commands:"
echo "  - View logs: docker compose -f docker-compose.prod.yml logs -f"
echo "  - Check status: docker compose -f docker-compose.prod.yml ps"
echo "  - Restart services: docker compose -f docker-compose.prod.yml restart"
echo "  - Update: git pull && ./scripts/deploy-production.sh"
echo ""
print_success "Your achpaudel.dev is now live in production! 🚀" 