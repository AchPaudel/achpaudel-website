#!/bin/bash

# Docker Build Fix Script for Angular Frontend
# This script fixes common Docker build issues

set -e

echo "🔧 Fixing Docker build issues..."

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

print_status "Cleaning up Docker cache..."
docker system prune -f

print_status "Removing existing frontend build artifacts..."
rm -rf frontend/node_modules
rm -rf frontend/package-lock.json
rm -rf frontend/dist

print_status "Installing dependencies locally to test..."
cd frontend
npm install --legacy-peer-deps

print_status "Testing local build..."
if npm run build; then
    print_success "Local build successful!"
else
    print_error "Local build failed. Please check the errors above."
    exit 1
fi

cd ..

print_status "Building Docker image with fixed configuration..."
cd docker

# Try building with the updated Dockerfile
if docker-compose build frontend; then
    print_success "Docker build successful!"
else
    print_warning "Standard build failed, trying alternative approach..."
    
    # Try with alternative Dockerfile
    cd ../frontend
    if docker build -f Dockerfile.alternative -t achpaudel-frontend-alternative .; then
        print_success "Alternative Docker build successful!"
        print_warning "You may need to update your docker-compose.yml to use the alternative image"
    else
        print_error "Both build approaches failed. Please check the errors above."
        exit 1
    fi
fi

print_success "Docker build fix complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Test the application: docker-compose up -d"
echo "  2. Check logs: docker-compose logs -f frontend"
echo "  3. Access the application: http://localhost:4200"
echo ""
print_success "Happy coding! 🚀" 