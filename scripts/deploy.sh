#!/bin/bash

# Achyut Paudel Website Deployment Script
# This script deploys the website to DreamCompute

set -e

echo "🚀 Starting deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop existing containers
print_status "Stopping existing containers..."
docker-compose down || true

# Pull latest changes if in git repository
if [ -d ".git" ]; then
    print_status "Pulling latest changes..."
    git pull origin main || print_warning "Could not pull latest changes"
fi

# Build and start containers
print_status "Building and starting containers..."
docker-compose up -d --build

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 30

# Test the deployment
print_status "Testing deployment..."

# Test backend health
if curl -f http://localhost/api/health > /dev/null 2>&1; then
    print_status "✅ Backend is healthy"
else
    print_error "❌ Backend health check failed"
    exit 1
fi

# Test frontend
if curl -f http://localhost > /dev/null 2>&1; then
    print_status "✅ Frontend is accessible"
else
    print_error "❌ Frontend is not accessible"
    exit 1
fi

print_status "🎉 Deployment completed successfully!"
print_status "🌐 Website: http://localhost"
print_status "🔧 API: http://localhost/api"
print_status "📚 Swagger: http://localhost/api/swagger-ui.html"

# Show container status
print_status "Container status:"
docker-compose ps 