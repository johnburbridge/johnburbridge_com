FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Copy version information if available
ARG VERSION=dev
LABEL org.opencontainers.image.version=${VERSION}

# Copy website files to Nginx serve directory
COPY site/ /usr/share/nginx/html/

# Add version info to site
RUN echo "${VERSION}" > /usr/share/nginx/html/version.txt

# Configure Nginx
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
