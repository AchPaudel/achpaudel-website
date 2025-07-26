# DreamCompute Server Setup Guide

## Prerequisites
- DreamCompute account activated
- SSH key pair generated
- Domain name: achpaudel.dev

## Step 1: Create DreamCompute Instance

### 1.1 Access DreamCompute Dashboard
1. Log into your DreamHost panel
2. Navigate to "Cloud Computing" → "DreamCompute"
3. Click "Create Instance"

### 1.2 Instance Configuration
- **Name**: achpaudel-website-server
- **Region**: Choose closest to your target audience
- **Image**: Ubuntu 22.04 LTS
- **Flavor**: 
  - **Development**: m1.small (1 vCPU, 2GB RAM, 20GB storage)
  - **Production**: m1.medium (2 vCPU, 4GB RAM, 40GB storage)
- **Key Pair**: Upload your SSH public key
- **Security Groups**: 
  - Default (SSH, ICMP)
  - Custom group for web ports (80, 443, 8080)

### 1.3 Network Configuration
- **Network**: Private network with floating IP
- **Floating IP**: Assign a public IP address

## Step 2: Server Initial Setup

### 2.1 Connect to Server
```bash
ssh ubuntu@YOUR_FLOATING_IP
```

### 2.2 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 2.3 Install Essential Packages
```bash
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release
```

## Step 3: Install Docker and Docker Compose

### 3.1 Install Docker
```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/vda

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Add user to docker group
sudo usermod -aG docker $USER
```

### 3.2 Install Docker Compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Step 4: Install Java 17

```bash
# Add OpenJDK repository
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update

# Install Java 17
sudo apt install -y openjdk-17-jdk

# Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Step 5: Install Node.js and npm

```bash
# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installation
node --version
npm --version
```

## Step 6: Install Nginx

```bash
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Step 7: Install Jenkins

```bash
# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## Step 8: Configure Firewall

```bash
# Install UFW if not present
sudo apt install -y ufw

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp  # Jenkins
sudo ufw allow 8081/tcp  # Spring Boot API
sudo ufw allow 4200/tcp  # Angular dev server

# Enable firewall
sudo ufw enable
```

## Step 9: Configure Domain DNS

1. Log into DreamHost panel
2. Go to "Domains" → "Manage Domains"
3. Add your DreamCompute floating IP to achpaudel.dev
4. Create subdomains:
   - `api.achpaudel.dev` → Backend API
   - `jenkins.achpaudel.dev` → Jenkins CI/CD

## Step 10: SSL Certificate Setup

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificates
sudo certbot --nginx -d achpaudel.dev -d www.achpaudel.dev
sudo certbot --nginx -d api.achpaudel.dev
sudo certbot --nginx -d jenkins.achpaudel.dev
```

## Step 11: Configure Nginx Reverse Proxy

Create Nginx configuration files for your applications.

## Step 12: Deploy Application

Follow the deployment guide in the project documentation.

## Security Checklist

- [ ] Change default SSH port
- [ ] Set up fail2ban
- [ ] Configure automatic security updates
- [ ] Set up monitoring and logging
- [ ] Regular backup strategy
- [ ] SSL certificates auto-renewal

## Next Steps

1. Clone your project repository
2. Set up Jenkins pipeline
3. Configure Docker containers
4. Deploy Spring Boot backend
5. Deploy Angular frontend
6. Set up database
7. Configure monitoring 