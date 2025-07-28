#!/bin/bash

# Achyut Paudel Website Setup Script
# This script helps set up the development environment

set -e

echo "🚀 Setting up Achyut Paudel Website"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check prerequisites
print_header "Checking Prerequisites"

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
else
    print_status "✅ Docker is installed"
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
else
    print_status "✅ Docker Compose is installed"
fi

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git is not installed. Please install Git first."
    exit 1
else
    print_status "✅ Git is installed"
fi

print_header "Setting up SSL Certificates"

# Create SSL directory
mkdir -p ssl


print_header "Building and Starting Services"

# Build and start containers
print_status "Building and starting Docker containers..."
docker-compose up -d --build

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 30

print_header "Testing Deployment"

# Test backend
print_status "Testing backend API..."
if curl -f http://localhost/api/health > /dev/null 2>&1; then
    print_status "✅ Backend API is healthy"
else
    print_warning "⚠️  Backend API health check failed. This might be normal during initial startup."
fi

# Test frontend
print_status "Testing frontend..."
if curl -f http://localhost > /dev/null 2>&1; then
    print_status "✅ Frontend is accessible"
else
    print_warning "⚠️  Frontend is not accessible yet. This might be normal during initial startup."
fi

print_header "Setup Complete!"

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Next Steps:"
echo "1. 🌐 Visit your website: http://localhost"
echo "2. 🔧 Test the API: http://localhost/api/health"
echo "3. 📚 View API docs: http://localhost/api/swagger-ui.html"
echo ""
echo "📁 Project Structure:"
echo "├── client/          # Angular frontend"
echo "├── server/          # Spring Boot backend"
echo "├── nginx/           # Nginx configuration"
echo "├── ssl/             # SSL certificates"
echo "└── scripts/         # Deployment scripts"
echo ""
echo "🛠️  Useful Commands:"
echo "• View logs: docker-compose logs -f"
echo "• Stop services: docker-compose down"
echo "• Restart services: docker-compose restart"
echo "• Deploy to production: ./scripts/deploy.sh"
echo "• Setup production SSL: ./scripts/setup-ssl.sh"
echo ""
echo "📚 Documentation:"
echo "• README.md - Complete project documentation"
echo "• API endpoints: http://localhost/api/swagger-ui.html"
echo ""
print_status "Happy coding! 🚀" 