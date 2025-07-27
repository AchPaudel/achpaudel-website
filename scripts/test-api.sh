#!/bin/bash

# API Test Script
# This script tests the API endpoints to ensure they're accessible

set -e

echo "🧪 Testing API endpoints..."

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

# Test API endpoints
print_status "Testing API endpoints..."

# Test health endpoint
print_status "Testing /api/health..."
if curl -s http://localhost:8081/api/health > /dev/null 2>&1; then
    print_success "✅ Health endpoint is accessible"
    curl -s http://localhost:8081/api/health | jq . 2>/dev/null || curl -s http://localhost:8081/api/health
else
    print_error "❌ Health endpoint not accessible"
fi

# Test test endpoint
print_status "Testing /api/test..."
if curl -s http://localhost:8081/api/test > /dev/null 2>&1; then
    print_success "✅ Test endpoint is accessible"
    curl -s http://localhost:8081/api/test | jq . 2>/dev/null || curl -s http://localhost:8081/api/test
else
    print_error "❌ Test endpoint not accessible"
fi

# Test projects endpoint
print_status "Testing /api/projects..."
if curl -s http://localhost:8081/api/projects > /dev/null 2>&1; then
    print_success "✅ Projects endpoint is accessible"
    curl -s http://localhost:8081/api/projects | jq . 2>/dev/null || curl -s http://localhost:8081/api/projects
else
    print_error "❌ Projects endpoint not accessible"
fi

# Test Swagger UI
print_status "Testing Swagger UI..."
if curl -s http://localhost:8081/swagger-ui.html > /dev/null 2>&1; then
    print_success "✅ Swagger UI is accessible"
else
    print_warning "⚠️  Swagger UI not accessible"
fi

print_status "API testing complete!"
echo ""
echo "🌐 API URLs:"
echo "  - Health: http://localhost:8081/api/health"
echo "  - Test: http://localhost:8081/api/test"
echo "  - Projects: http://localhost:8081/api/projects"
echo "  - Swagger UI: http://localhost:8081/swagger-ui.html"
echo ""
print_success "API testing finished! 🚀" 