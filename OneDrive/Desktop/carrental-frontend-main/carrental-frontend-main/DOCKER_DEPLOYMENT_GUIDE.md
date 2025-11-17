# CRMS Frontend - Docker Deployment Guide

## Overview
This guide provides instructions for deploying the CRMS (Car Rental Management System) Frontend using Docker and Docker Compose.

## Prerequisites
- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- Git (for version control)

## Quick Start

### Production Deployment

1. **Build and Run with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

2. **Verify the deployment:**
   ```bash
   docker-compose ps
   ```

3. **Access the application:**
   - Open your browser and navigate to: `http://localhost:3000`

4. **View logs:**
   ```bash
   docker-compose logs -f crms-frontend
   ```

5. **Stop the application:**
   ```bash
   docker-compose down
   ```

### Development Deployment

1. **Run development environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```

2. **Access the development server:**
   - Open your browser and navigate to: `http://localhost:5173`

3. **Stop development environment:**
   ```bash
   docker-compose -f docker-compose.dev.yml down
   ```

## Docker Images

### Production Image
- **Base Image:** `node:20-alpine`
- **Size:** Optimized with multi-stage builds
- **Ports:** 3000
- **Process:** Serves built React application using `serve`

### Development Image
- **Base Image:** `node:20-alpine`
- **Ports:** 5173 (Vite dev server)
- **Features:** Hot module reloading, mounted volumes

## Configuration

### Environment Variables
Create a `.env` file in the project root or use `.env.example` as a template:

```env
VITE_API_URL=http://localhost:8080
NODE_ENV=production
```

### Port Configuration
- **Production:** Port 3000 (configurable in docker-compose.yml)
- **Development:** Port 5173 (configurable in docker-compose.dev.yml)

## Common Commands

### Build the image
```bash
docker-compose build
```

### Run container in background
```bash
docker-compose up -d
```

### Run container in foreground
```bash
docker-compose up
```

### View container logs
```bash
docker-compose logs -f crms-frontend
```

### Execute commands in container
```bash
docker-compose exec crms-frontend sh
```

### Remove containers and volumes
```bash
docker-compose down -v
```

### Rebuild without cache
```bash
docker-compose build --no-cache
```

## Health Check
The production container includes a health check that verifies the application is running every 30 seconds.

View health status:
```bash
docker-compose ps
```

## Network Configuration
- **Network Name:** `crms-network`
- **Driver:** Bridge
- Allows communication between containers if extending to multi-service deployment

## Troubleshooting

### Port Already in Use
If port 3000 or 5173 is already in use:

1. **Change the port in docker-compose.yml:**
   ```yaml
   ports:
     - "8000:3000"  # Maps host port 8000 to container port 3000
   ```

2. **Restart the containers:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

### Build Failures
Clear build cache and rebuild:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Application Not Responding
Check logs and health:
```bash
docker-compose logs crms-frontend
docker-compose ps
```

## Performance Optimization

- **Multi-stage builds:** Reduces final image size
- **Alpine Linux base:** Lightweight OS (~5MB)
- **npm ci instead of npm install:** Ensures reproducible builds
- **Volume mounts (dev):** Enables hot reloading

## Security Considerations

1. Use `.dockerignore` to exclude sensitive files
2. Keep Docker images updated
3. Use specific Node.js version instead of `latest`
4. Run containers as non-root user (can be added for production)
5. Implement proper environment variable management

## Git Integration

After completing deployment:

1. **Stage changes:**
   ```bash
   git add .
   ```

2. **Commit changes:**
   ```bash
   git commit -m "Add Docker and Docker Compose configuration for CRMS frontend"
   ```

3. **Push to GitHub:**
   ```bash
   git push origin main
   ```

## Support
For issues or questions, please refer to the main README.md or check Docker documentation.
