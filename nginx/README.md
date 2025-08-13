# Nginx Configuration

This directory contains the Nginx configuration for the SWIVEL web application.

## Files

- **default.conf** - Main Nginx server configuration

## Configuration Details

The `default.conf` file configures Nginx to:
- Listen on port 80
- Serve static files from `/usr/share/nginx/html/`
- Handle the main application routes
- Provide proper MIME type handling

## Usage

This configuration is automatically copied into the Docker container during the build process via the Dockerfile:

```dockerfile
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
```

## Customization

To modify the Nginx configuration:
1. Edit `default.conf`
2. Rebuild the Docker image
3. Deploy the updated image through the Application Deployment workflow

## Default Behavior

- Serves the `index.html` file as the main page
- Handles static file serving
- Configured for the SWIVEL demo application 