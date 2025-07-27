#!/bin/bash

# Nginx Configuration Test and Restart Script
# This script tests nginx configuration and restarts the service

set -e

echo "🔧 Testing nginx configuration and restarting service..."

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

# Check if we're in the docker directory
if [ ! -f "docker-compose.yml" ]; then
    print_error "Please run this script from the docker directory"
    exit 1
fi

print_status "Stopping nginx container..."
docker compose stop nginx

print_status "Testing nginx configuration..."
docker compose run --rm nginx nginx -t

if [ $? -eq 0 ]; then
    print_success "Nginx configuration is valid"
else
    print_error "Nginx configuration has errors"
    exit 1
fi

print_status "Starting nginx with fixed configuration..."
docker compose up -d nginx

print_status "Waiting for nginx to start..."
sleep 5

# Check nginx status
print_status "Checking nginx status..."
if docker compose ps nginx | grep -q "Up"; then
    print_success "Nginx is running successfully!"
else
    print_error "Nginx failed to start. Checking logs..."
    docker compose logs nginx
    exit 1
fi

# Test endpoints
print_status "Testing endpoints..."

# Test main site
if curl -s http://localhost:82 > /dev/null 2>&1; then
    print_success "Main site is accessible at http://localhost:82"
else
    print_warning "Main site not responding yet"
fi

# Test API
if curl -s http://localhost:8081/api/test > /dev/null 2>&1; then
    print_success "API test endpoint is accessible"
else
    print_warning "API test endpoint not responding yet"
fi

# Test Jenkins
if curl -s http://localhost:8082 > /dev/null 2>&1; then
    print_success "Jenkins is accessible at http://localhost:8082"
else
    print_warning "Jenkins not responding yet"
fi

print_success "Nginx configuration test complete!"
echo ""
echo "📝 Service URLs:"
echo "  - Main site: http://localhost:82"
echo "  - Frontend: http://localhost:4201"
echo "  - Backend API: http://localhost:8081/api"
echo "  - API Test: http://localhost:8081/api/test"
echo "  - Jenkins: http://localhost:8082"
echo "  - Database: localhost:5432"
echo ""
echo "🔍 Useful commands:"
echo "  - View nginx logs: docker compose logs -f nginx"
echo "  - Test nginx config: docker compose run --rm nginx nginx -t"
echo "  - Restart nginx: docker compose restart nginx"
echo "  - Check all services: docker compose ps"
echo ""
print_success "Happy coding! 🚀" 