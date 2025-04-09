FROM nginx:alpine

# Copy website files to Nginx serve directory
COPY site/ /usr/share/nginx/html/

# Configure Nginx
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
