#!/bin/bash

# Port Conflict Fix Script for Achyut Dev Site
# This script resolves port conflicts and manages Docker services

set -e

echo "🔧 Fixing port conflicts and managing Docker services..."

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

# Function to check if port is in use
check_port() {
    local port=$1
    if lsof -i :$port > /dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to kill process using port
kill_port() {
    local port=$1
    print_status "Checking port $port..."
    if check_port $port; then
        print_warning "Port $port is in use. Attempting to free it..."
        sudo lsof -ti:$port | xargs sudo kill -9 2>/dev/null || true
        sleep 2
        if check_port $port; then
            print_error "Could not free port $port"
            return 1
        else
            print_success "Port $port is now free"
        fi
    else
        print_success "Port $port is free"
    fi
}

# Stop all containers first
print_status "Stopping all containers..."
docker-compose down

# Check and free ports
print_status "Checking for port conflicts..."

# Check common ports
ports=(8080 8081 8082 4200 4201 5432 6379 80 443 50000)

for port in "${ports[@]}"; do
    kill_port $port
done

# Clean up Docker resources
print_status "Cleaning up Docker resources..."
docker system prune -f

# Start services one by one
print_status "Starting services..."

# Start database first
print_status "Starting database..."
docker-compose up -d db
sleep 5

# Start backend
print_status "Starting backend..."
docker-compose up -d backend
sleep 10

# Start frontend
print_status "Starting frontend..."
docker-compose up -d frontend
sleep 5

# Start other services
print_status "Starting remaining services..."
docker-compose up -d redis nginx jenkins

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 15

# Check service status
print_status "Checking service status..."
docker-compose ps

# Test endpoints
print_status "Testing endpoints..."

# Test backend
if curl -s http://localhost:8081/api/projects > /dev/null 2>&1; then
    print_success "Backend API is responding"
else
    print_warning "Backend API not responding yet (may need more time)"
fi

# Test frontend
if curl -s http://localhost:4201 > /dev/null 2>&1; then
    print_success "Frontend is responding"
else
    print_warning "Frontend not responding yet (may need more time)"
fi

# Test Jenkins
if curl -s http://localhost:8082 > /dev/null 2>&1; then
    print_success "Jenkins is responding"
else
    print_warning "Jenkins not responding yet (may need more time)"
fi

print_success "Port conflict resolution complete!"
echo ""
echo "📝 Service URLs:"
echo "  - Frontend: http://localhost:4201"
echo "  - Backend API: http://localhost:8081/api"
echo "  - Swagger UI: http://localhost:8081/swagger-ui.html"
echo "  - Jenkins: http://localhost:8082"
echo "  - Database: localhost:5432"
echo "  - Redis: localhost:6379"
echo ""
echo "🔍 Useful commands:"
echo "  - View logs: docker-compose logs -f"
echo "  - Stop services: docker-compose down"
echo "  - Restart services: docker-compose restart"
echo ""
print_success "Happy coding! 🚀" 