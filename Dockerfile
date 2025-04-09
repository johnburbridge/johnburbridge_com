FROM nginx:alpine

# Copy website files to Nginx serve directory
COPY . /usr/share/nginx/html/

# Remove the Dockerfile from the copied content
RUN rm /usr/share/nginx/html/Dockerfile

# Configure Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
