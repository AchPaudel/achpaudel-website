#!/bin/bash

# SSL Certificate Setup Script for achpaudel.dev
# This script helps set up SSL certificates for the website

set -e

echo "🔐 SSL Certificate Setup for achpaudel.dev"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Create SSL directory
print_status "Creating SSL directory..."
mkdir -p ssl

# Check if certificates already exist
if [ -f "ssl/achpaudel.dev.crt" ] && [ -f "ssl/achpaudel.dev.key" ]; then
    print_warning "SSL certificates already exist."
    read -p "Do you want to regenerate them? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Regenerating SSL certificates..."
    else
        print_status "Using existing certificates."
        exit 0
    fi
fi

# Ask user for certificate type
echo "Choose certificate type:"
echo "1) Self-signed certificate (for testing)"
echo "2) Let's Encrypt certificate (for production)"
read -p "Enter your choice (1 or 2): " -n 1 -r
echo

if [[ $REPLY =~ ^[1]$ ]]; then
    # Generate self-signed certificate
    print_status "Generating self-signed certificate..."
    
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ssl/achpaudel.dev.key \
        -out ssl/achpaudel.dev.crt \
        -subj "/C=US/ST=State/L=City/O=Achyut Paudel/CN=achpaudel.dev"
    
    print_status "✅ Self-signed certificate generated successfully!"
    print_warning "⚠️  Self-signed certificates will show security warnings in browsers."
    
elif [[ $REPLY =~ ^[2]$ ]]; then
    # Let's Encrypt certificate
    print_status "Setting up Let's Encrypt certificate..."
    
    # Check if certbot is installed
    if ! command -v certbot &> /dev/null; then
        print_status "Installing certbot..."
        sudo apt update
        sudo apt install -y certbot
    fi
    
    # Stop nginx temporarily for standalone mode
    print_status "Stopping nginx for certificate generation..."
    docker-compose stop frontend || true
    
    # Get certificate
    print_status "Obtaining Let's Encrypt certificate..."
    sudo certbot certonly --standalone -d achpaudel.dev -d www.achpaudel.dev
    
    # Copy certificates
    print_status "Copying certificates..."
    sudo cp /etc/letsencrypt/live/achpaudel.dev/fullchain.pem ssl/achpaudel.dev.crt
    sudo cp /etc/letsencrypt/live/achpaudel.dev/privkey.pem ssl/achpaudel.dev.key
    
    # Set proper permissions
    sudo chown $USER:$USER ssl/achpaudel.dev.crt ssl/achpaudel.dev.key
    chmod 600 ssl/achpaudel.dev.key
    chmod 644 ssl/achpaudel.dev.crt
    
    # Restart nginx
    print_status "Restarting nginx..."
    docker-compose up -d frontend
    
    print_status "✅ Let's Encrypt certificate generated successfully!"
    
    # Set up auto-renewal
    print_status "Setting up auto-renewal..."
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    
else
    print_error "Invalid choice. Please run the script again."
    exit 1
fi

print_status "🔐 SSL certificate setup completed!"
print_status "📁 Certificates are in the ssl/ directory"
print_status "🚀 You can now deploy with SSL support using: ./scripts/deploy.sh" 