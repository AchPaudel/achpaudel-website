#!/bin/bash

# Java 17 Installation Script for macOS
# This script installs Java 17 using Homebrew

set -e

echo "🚀 Installing Java 17 for Achyut Dev Site..."

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

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed"
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    
    print_success "Homebrew installed"
else
    print_success "Homebrew is already installed"
fi

# Check current Java version
print_status "Current Java version:"
java -version

# Install Java 17
print_status "Installing OpenJDK 17..."
brew install openjdk@17

# Link Java 17
print_status "Linking Java 17..."
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# Set JAVA_HOME
print_status "Setting JAVA_HOME..."
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@17' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc

# Reload shell configuration
source ~/.zshrc

# Verify installation
print_status "Verifying Java 17 installation..."
if java -version 2>&1 | grep -q "17"; then
    print_success "Java 17 installed successfully!"
    java -version
else
    print_error "Java 17 installation failed"
    exit 1
fi

# Test Maven wrapper
print_status "Testing Maven wrapper..."
cd backend
if ./mvnw -version; then
    print_success "Maven wrapper is working!"
else
    print_error "Maven wrapper failed"
    exit 1
fi

print_success "Java 17 installation complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Navigate to the backend directory: cd backend"
echo "  3. Run the application: ./mvnw spring-boot:run"
echo ""
echo "🌐 The application will be available at:"
echo "  - Backend API: http://localhost:8081/api"
echo "  - Swagger UI: http://localhost:8081/swagger-ui.html"
echo "  - H2 Console: http://localhost:8081/h2-console"
echo ""
print_success "Happy coding! 🚀" 