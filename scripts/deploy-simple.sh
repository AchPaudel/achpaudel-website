#!/bin/bash

# Simplified Production Deployment Script for achpaudel.dev
# This script deploys the application without Jenkins and API subdomains

set -e

echo "🚀 Deploying achpaudel.dev (simplified version)..."

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

# Check if docker-compose.yml exists
if [ ! -f "docker/docker-compose.yml" ]; then
    print_error "docker-compose.yml not found in docker directory"
    exit 1
fi

print_status "Stopping all existing containers..."
cd docker
docker compose down

print_status "Building all services with production configuration..."
docker compose build --no-cache

print_status "Starting database..."
docker compose up -d db
sleep 10

print_status "Starting backend..."
docker compose up -d backend
sleep 15

print_status "Starting frontend..."
docker compose up -d frontend
sleep 10

print_status "Starting Redis..."
docker compose up -d redis
sleep 5

print_status "Starting nginx..."
docker compose up -d nginx
sleep 5

# Check all services
print_status "Checking service status..."
docker compose ps

# Test endpoints
print_status "Testing production endpoints..."

# Test main site
if curl -s http://localhost:82 > /dev/null 2>&1; then
    print_success "✅ Main site (achpaudel.dev) is accessible"
else
    print_warning "⚠️  Main site not responding yet"
fi

# Test API through main site
if curl -s http://localhost:8081/api/test > /dev/null 2>&1; then
    print_success "✅ API is accessible"
else
    print_warning "⚠️  API not responding yet"
fi

# Test frontend directly
if curl -s http://localhost:4201 > /dev/null 2>&1; then
    print_success "✅ Frontend is accessible"
else
    print_warning "⚠️  Frontend not responding yet"
fi

print_success "Simplified production deployment complete!"
echo ""
echo "🌐 Production URLs:"
echo "  - Main site: http://achpaudel.dev (port 82)"
echo "  - Frontend direct: http://localhost:4201"
echo "  - Backend API: http://localhost:8081/api"
echo "  - Database: localhost:5432"
echo "  - Redis: localhost:6379"
echo ""
echo "🔧 Next Steps for SSL:"
echo "  1. Install Certbot: sudo apt install certbot python3-certbot-nginx"
echo "  2. Get SSL certificate: sudo certbot --nginx -d achpaudel.dev -d www.achpaudel.dev"
echo ""
echo "🔍 Useful commands:"
echo "  - View logs: docker compose logs -f"
echo "  - Check status: docker compose ps"
echo "  - Restart services: docker compose restart"
echo "  - Update: git pull && ./scripts/deploy-simple.sh"
echo ""
print_success "Your achpaudel.dev is now live! 🎉" 