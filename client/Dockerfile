# Build stage
FROM node:18 as build

WORKDIR /app

# Copy package files
COPY client/package*.json ./

# Install dependencies with legacy peer deps to handle Angular dependencies
RUN npm install --omit=dev --legacy-peer-deps

# Copy source code
COPY client/ .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built application
COPY --from=build /app/dist/achpaudel-website /usr/share/nginx/html

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificates
COPY ssl/bundle.crt /etc/nginx/ssl/bundle.crt
COPY ssl/www_achpaudel_dev.key /etc/nginx/ssl/www_achpaudel_dev.key


# Expose ports
EXPOSE 80 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 