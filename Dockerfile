# Stage 1: Build the Astro site
FROM node:20-alpine AS builder

# Set working directory for the build stage
WORKDIR /app

# Copy necessary files for building
COPY package*.json ./
COPY astro.config.mjs ./
# COPY tsconfig.json ./  # Astro often generates/needs this - skip for now unless needed
COPY src/ ./src/
COPY public/ ./public/

# Install dependencies
RUN npm ci

# Build the static site
RUN npm run build

# Stage 2: Serve the built site with Nginx
FROM nginx:alpine

# Set working directory for Nginx
WORKDIR /usr/share/nginx/html

# Copy version information if available
ARG VERSION=dev
LABEL org.opencontainers.image.version=${VERSION}

# Remove default Nginx content
RUN rm -rf ./*

# Copy built site from the builder stage
COPY --from=builder /app/dist/ .

# Copy custom Nginx configuration
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
