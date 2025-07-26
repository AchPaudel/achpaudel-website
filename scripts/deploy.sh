#!/bin/bash

# Achyut Dev Site Deployment Script
# This script deploys the application to DreamCompute server

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="achpaudel-website"
DOCKER_COMPOSE_FILE="docker/docker-compose.yml"
BACKUP_DIR="/opt/backups"
LOG_FILE="/var/log/achpaudel-deploy.log"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a $LOG_FILE
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a $LOG_FILE
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a $LOG_FILE
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a $LOG_FILE
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

# Function to check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &> /dev/null; then
        error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    log "All prerequisites are satisfied."
}

# Function to backup current deployment
backup_current() {
    log "Creating backup of current deployment..."
    
    if [ -d "$BACKUP_DIR" ]; then
        BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S)"
        sudo mkdir -p "$BACKUP_DIR/$BACKUP_NAME"
        
        # Backup Docker volumes
        if docker volume ls | grep -q "achpaudel"; then
            docker run --rm -v achpaudel-website_postgres_data:/data -v "$BACKUP_DIR/$BACKUP_NAME":/backup alpine tar czf /backup/postgres_data.tar.gz -C /data .
            log "Database backup created: $BACKUP_DIR/$BACKUP_NAME/postgres_data.tar.gz"
        fi
        
        # Backup configuration files
        if [ -d "/opt/$PROJECT_NAME" ]; then
            sudo cp -r /opt/$PROJECT_NAME "$BACKUP_DIR/$BACKUP_NAME/"
            log "Configuration backup created"
        fi
    fi
}

# Function to pull latest code
pull_latest_code() {
    log "Pulling latest code from repository..."
    
    cd /opt/$PROJECT_NAME
    
    # Stash any local changes
    git stash
    
    # Pull latest changes
    git pull origin main
    
    log "Latest code pulled successfully."
}

# Function to build and deploy
deploy_application() {
    log "Building and deploying application..."
    
    cd /opt/$PROJECT_NAME
    
    # Stop existing containers
    log "Stopping existing containers..."
    docker-compose -f $DOCKER_COMPOSE_FILE down
    
    # Build new images
    log "Building Docker images..."
    docker-compose -f $DOCKER_COMPOSE_FILE build --no-cache
    
    # Start containers
    log "Starting containers..."
    docker-compose -f $DOCKER_COMPOSE_FILE up -d
    
    # Wait for services to be ready
    log "Waiting for services to be ready..."
    sleep 30
    
    # Check if services are running
    if docker-compose -f $DOCKER_COMPOSE_FILE ps | grep -q "Up"; then
        log "Application deployed successfully!"
    else
        error "Deployment failed. Check container logs."
        docker-compose -f $DOCKER_COMPOSE_FILE logs
        exit 1
    fi
}

# Function to run tests
run_tests() {
    log "Running tests..."
    
    cd /opt/$PROJECT_NAME
    
    # Backend tests
    if [ -d "backend" ]; then
        log "Running backend tests..."
        cd backend
        ./mvnw test
        cd ..
    fi
    
    # Frontend tests (if needed)
    if [ -d "frontend" ]; then
        log "Running frontend tests..."
        cd frontend
        npm test -- --watch=false
        cd ..
    fi
}

# Function to update SSL certificates
update_ssl() {
    log "Updating SSL certificates..."
    
    # Renew certificates
    sudo certbot renew --quiet
    
    # Reload Nginx
    sudo systemctl reload nginx
    
    log "SSL certificates updated."
}

# Function to monitor deployment
monitor_deployment() {
    log "Monitoring deployment..."
    
    # Check container health
    docker-compose -f $DOCKER_COMPOSE_FILE ps
    
    # Check application endpoints
    log "Checking application endpoints..."
    
    # Check if backend is responding
    if curl -f http://localhost:8081/api/health &> /dev/null; then
        log "Backend is healthy"
    else
        warning "Backend health check failed"
    fi
    
    # Check if frontend is responding
    if curl -f http://localhost:4200 &> /dev/null; then
        log "Frontend is healthy"
    else
        warning "Frontend health check failed"
    fi
}

# Function to rollback
rollback() {
    log "Rolling back to previous deployment..."
    
    # Stop current containers
    docker-compose -f $DOCKER_COMPOSE_FILE down
    
    # Find latest backup
    LATEST_BACKUP=$(ls -t $BACKUP_DIR | head -1)
    
    if [ -n "$LATEST_BACKUP" ]; then
        log "Restoring from backup: $LATEST_BACKUP"
        
        # Restore configuration
        sudo cp -r "$BACKUP_DIR/$LATEST_BACKUP/$PROJECT_NAME" /opt/
        
        # Restart containers
        cd /opt/$PROJECT_NAME
        docker-compose -f $DOCKER_COMPOSE_FILE up -d
        
        log "Rollback completed."
    else
        error "No backup found for rollback."
        exit 1
    fi
}

# Main deployment function
main() {
    log "Starting deployment process..."
    
    # Create log file
    sudo touch $LOG_FILE
    sudo chown $USER:$USER $LOG_FILE
    
    # Check prerequisites
    check_prerequisites
    
    # Backup current deployment
    backup_current
    
    # Pull latest code
    pull_latest_code
    
    # Run tests
    run_tests
    
    # Deploy application
    deploy_application
    
    # Update SSL certificates
    update_ssl
    
    # Monitor deployment
    monitor_deployment
    
    log "Deployment completed successfully!"
}

# Parse command line arguments
case "$1" in
    "deploy")
        main
        ;;
    "rollback")
        rollback
        ;;
    "test")
        run_tests
        ;;
    "backup")
        backup_current
        ;;
    "monitor")
        monitor_deployment
        ;;
    *)
        echo "Usage: $0 {deploy|rollback|test|backup|monitor}"
        echo "  deploy   - Full deployment process"
        echo "  rollback - Rollback to previous deployment"
        echo "  test     - Run tests only"
        echo "  backup   - Create backup only"
        echo "  monitor  - Monitor deployment health"
        exit 1
        ;;
esac 