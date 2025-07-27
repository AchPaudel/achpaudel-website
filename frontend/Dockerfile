# Build stage
FROM node:18-alpine as build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with legacy peer deps to fix Rollup issues
RUN npm ci --legacy-peer-deps --force

# Copy source code
COPY . .

# Build the application
RUN npm run build:docker

# Production stage
FROM nginx:alpine

# Copy built application
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Copy nginx configuration
COPY /home/ubuntu/achpaudel-website/docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 