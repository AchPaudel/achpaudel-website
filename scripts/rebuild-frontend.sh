#!/bin/bash

# Frontend Rebuild Script
# This script rebuilds the frontend with the correct nginx configuration

set -e

echo "🔧 Rebuilding frontend with correct nginx configuration..."

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

# Check if frontend nginx.conf exists
if [ ! -f "../frontend/nginx.conf" ]; then
    print_error "Frontend nginx.conf not found!"
    exit 1
fi

print_status "Stopping frontend and nginx containers..."
docker compose stop frontend nginx

print_status "Removing old frontend container..."
docker compose rm -f frontend

print_status "Rebuilding frontend with correct nginx configuration..."
docker compose build --no-cache frontend

if [ $? -eq 0 ]; then
    print_success "Frontend built successfully"
else
    print_error "Frontend build failed"
    exit 1
fi

print_status "Starting frontend..."
docker compose up -d frontend

print_status "Waiting for frontend to start..."
sleep 10

# Check frontend status
print_status "Checking frontend status..."
if docker compose ps frontend | grep -q "Up"; then
    print_success "Frontend is running successfully!"
else
    print_error "Frontend failed to start. Checking logs..."
    docker compose logs frontend
    exit 1
fi

print_status "Starting nginx..."
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

# Test frontend directly
if curl -s http://localhost:4201 > /dev/null 2>&1; then
    print_success "Frontend is accessible at http://localhost:4201"
else
    print_warning "Frontend not responding at http://localhost:4201"
fi

# Test main site through nginx
if curl -s http://localhost:82 > /dev/null 2>&1; then
    print_success "Main site is accessible at http://localhost:82"
    
    # Check if it's serving the Angular app
    response=$(curl -s http://localhost:82)
    if echo "$response" | grep -q "app-root"; then
        print_success "✅ achpaudel.dev is serving the Angular application!"
    else
        print_warning "⚠️  achpaudel.dev is responding but may not be serving Angular app"
        echo "Response preview:"
        echo "$response" | head -10
    fi
else
    print_warning "Main site not responding at http://localhost:82"
fi

# Test frontend health endpoint
if curl -s http://localhost:4201/health > /dev/null 2>&1; then
    print_success "Frontend health endpoint is working"
else
    print_warning "Frontend health endpoint not responding"
fi

print_success "Frontend rebuild complete!"
echo ""
echo "📝 Service URLs:"
echo "  - Main site (achpaudel.dev): http://localhost:82"
echo "  - Frontend direct: http://localhost:4201"
echo "  - Frontend health: http://localhost:4201/health"
echo "  - Backend API: http://localhost:8081/api"
echo "  - Jenkins: http://localhost:8082"
echo ""
echo "🔍 Useful commands:"
echo "  - View frontend logs: docker compose logs -f frontend"
echo "  - View nginx logs: docker compose logs -f nginx"
echo "  - Test nginx config: docker compose run --rm nginx nginx -t"
echo "  - Check all services: docker compose ps"
echo ""
print_success "Happy coding! 🚀" 