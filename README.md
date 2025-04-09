# John Burbridge - Personal Website

## Overview
This is the personal website for John Burbridge, a DevEx Engineering Consultant and founder of Spiral House.

## Structure

This website uses plain HTML and CSS:

- `index.html` - Main HTML content
- `styles.css` - All styling
- `script.js` - JavaScript for navigation and smooth scrolling
- `CNAME` - For GitHub Pages custom domain configuration

## Building

1. Build the Docker image:
   ```
   docker build -t johnburbridge-website .
   ```

2. Run the container:
   ```
   docker run -d -p 80:80 johnburbridge-website
   ```

3. Access the website at http://localhost:8080

For production deployment with Docker:

1. Push the image to a container registry
2. Deploy to the preferred hosting platform (AWS, GCP, Azure, Digital Ocean, etc.)
3. Configure the domain DNS to point to your the provider


