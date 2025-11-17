# CRMS Frontend - Docker Deployment Setup Guide for Admins

## Executive Summary

The CRMS (Car Rental Management System) Frontend now supports Docker deployment, enabling single-command deployment scenarios. This guide provides step-by-step instructions for the admin team to deploy the application using Docker and Docker Compose.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start Guide](#quick-start-guide)
3. [Deployment Scenarios](#deployment-scenarios)
4. [Troubleshooting](#troubleshooting)
5. [Production Best Practices](#production-best-practices)
6. [Support and Resources](#support-and-resources)

---

## Prerequisites

### System Requirements

- **OS**: Windows, macOS, or Linux
- **CPU**: 2+ cores recommended
- **RAM**: 2GB minimum (4GB recommended)
- **Storage**: 3GB free space

### Software Requirements

1. **Docker Desktop**
   - Windows/macOS: [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
   - Linux: Install Docker Community Edition
   - Verify installation:
     ```bash
     docker --version      # Should show Docker version 20.10+
     docker-compose --version  # Should show version 2.0+
     ```

2. **Git** (for version control)
   - [Download Git](https://git-scm.com/)
   - Verify installation:
     ```bash
     git --version
     ```

### Environment Setup

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd carrental-frontend-main
   ```

2. **Verify Repository Contents**
   ```bash
   # Windows
   dir /B | findstr "Docker docker compose env\.example"
   
   # macOS/Linux
   ls -la | grep -E "Docker|docker|compose|env"
   ```

   You should see:
   - `Dockerfile` (Production)
   - `Dockerfile.dev` (Development)
   - `docker-compose.yml` (Production compose)
   - `docker-compose.dev.yml` (Development compose)
   - `.dockerignore`
   - `.env.example`

---

## Quick Start Guide

### One-Command Deployment (Production)

```bash
# Navigate to project directory
cd carrental-frontend-main

# Start the application
docker-compose up -d

# Verify deployment
docker-compose ps

# Access the application
# Open browser: http://localhost:3000
```

### Using Deployment Scripts

**Windows Users:**
```cmd
# Navigate to project directory
cd carrental-frontend-main

# Run deployment script (if preferred)
deploy.bat start

# View logs
deploy.bat logs

# Stop application
deploy.bat stop
```

**macOS/Linux Users:**
```bash
# Make script executable
chmod +x deploy.sh

# Run deployment script
./deploy.sh start

# View logs
./deploy.sh logs

# Stop application
./deploy.sh stop
```

---

## Deployment Scenarios

### Scenario 1: Production Deployment (Recommended for Admin Team)

**Command:**
```bash
docker-compose up -d
```

**What happens:**
1. Builds the production Docker image (if not exists)
2. Creates and starts a container on port 3000
3. Application runs in background
4. Health checks enabled

**Access Application:**
- URL: `http://localhost:3000`
- Container name: `crms-frontend-app`

**Verify Deployment:**
```bash
# Check container status
docker-compose ps

# View logs (last 50 lines)
docker-compose logs crms-frontend

# View live logs
docker-compose logs -f crms-frontend

# Test health
curl http://localhost:3000
```

### Scenario 2: Development Deployment

**Command:**
```bash
docker-compose -f docker-compose.dev.yml up
```

**Features:**
- Hot reload enabled
- Source code mounted
- Development dependencies installed
- Port 5173 (Vite dev server)

**Access Application:**
- URL: `http://localhost:5173`

### Scenario 3: Custom Port Configuration

**Edit `docker-compose.yml`:**
```yaml
services:
  crms-frontend:
    ports:
      - "8080:3000"  # Change host port from 3000 to 8080
```

**Deploy:**
```bash
docker-compose up -d
# Access: http://localhost:8080
```

### Scenario 4: Environment-Specific Deployment

**Create `.env` file:**
```bash
# Copy from example
cp .env.example .env

# Edit configuration
# For Linux/macOS: nano .env
# For Windows: notepad .env

# Configure:
VITE_API_URL=https://api.production.com
NODE_ENV=production
```

**Deploy:**
```bash
docker-compose up -d
```

---

## Common Operations

### View Application Logs

```bash
# Last 50 lines
docker-compose logs crms-frontend

# Last 100 lines
docker-compose logs --tail=100 crms-frontend

# Live logs (press Ctrl+C to stop)
docker-compose logs -f crms-frontend
```

### Stop Application

```bash
# Stop containers (keep data)
docker-compose stop

# Resume containers
docker-compose start

# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes
docker-compose down -v
```

### Restart Application

```bash
# Simple restart
docker-compose restart

# Full restart (recommended)
docker-compose down
docker-compose up -d
```

### Rebuild Application

```bash
# Rebuild image without cache
docker-compose build --no-cache

# Deploy new image
docker-compose up -d
```

### Access Container Shell

```bash
# Execute shell in running container
docker-compose exec crms-frontend sh

# Exit shell
exit
```

### Check Container Health

```bash
# View health status
docker-compose ps

# Manual health check
curl http://localhost:3000
```

### View Resource Usage

```bash
# Windows
docker ps

# Check container stats
docker stats crms-frontend
```

---

## Troubleshooting

### Issue: Port 3000 Already in Use

**Solution:**
```bash
# Option 1: Find what's using port 3000
# Windows
netstat -ano | findstr :3000

# macOS/Linux
lsof -i :3000

# Option 2: Use different port
# Edit docker-compose.yml, change "3000:3000" to "8000:3000"
docker-compose up -d
```

### Issue: Application Not Responding

**Solution:**
```bash
# Check container status
docker-compose ps

# View logs for errors
docker-compose logs crms-frontend

# Restart container
docker-compose restart

# Rebuild if issues persist
docker-compose build --no-cache
docker-compose up -d
```

### Issue: Build Fails

**Solution:**
```bash
# Clear Docker cache
docker system prune -a

# Rebuild
docker-compose build --no-cache

# Deploy
docker-compose up -d
```

### Issue: Permissions Denied (Linux)

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply group changes
newgrp docker

# Verify
docker ps
```

### Issue: Docker Daemon Not Running

**Solution:**
- **Windows**: Start "Docker Desktop" application
- **macOS**: Start "Docker" from Applications
- **Linux**: 
  ```bash
  sudo systemctl start docker
  sudo systemctl enable docker  # Auto-start on boot
  ```

### Issue: Out of Disk Space

**Solution:**
```bash
# Check disk usage
docker system df

# Clean up unused images/containers
docker system prune

# Remove all unused resources
docker system prune -a
```

---

## Production Best Practices

### 1. Environment Configuration

```bash
# Create production .env
VITE_API_URL=https://api.production.example.com
NODE_ENV=production
VITE_APP_NAME=CRMS
```

### 2. Resource Limits

**Edit `docker-compose.yml`:**
```yaml
services:
  crms-frontend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

### 3. Logging Strategy

```bash
# View structured logs
docker-compose logs --timestamps crms-frontend

# Export logs to file
docker-compose logs crms-frontend > logs.txt
```

### 4. Backup and Recovery

```bash
# Create backup of environment
cp .env .env.backup

# Backup containers
docker-compose ps  # Document running containers

# Disaster recovery - restore
cp .env.backup .env
docker-compose down -v
docker-compose up -d
```

### 5. Security Considerations

- Never commit `.env` file to Git
- Use `.env.example` as template only
- Restrict port access via firewall
- Keep Docker images updated
- Scan images for vulnerabilities:
  ```bash
  docker scan crms-frontend-app
  ```

### 6. Monitoring and Alerts

```bash
# Monitor container health
docker-compose ps

# Set up log aggregation (optional)
docker-compose logs --follow crms-frontend
```

---

## Advanced Configuration

### SSL/TLS Setup

**Create reverse proxy (nginx) - optional**
- Configure nginx container
- Map port 443 to 80
- Certificate management with Let's Encrypt

### Multi-Environment Setup

**Create docker-compose.prod.yml for production:**
```yaml
version: '3.9'

services:
  crms-frontend:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "443:3000"
    environment:
      - NODE_ENV=production
      - VITE_API_URL=https://api.prod.com
    restart: always
    # Additional production configs
```

**Deploy:**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

---

## Maintenance Schedule

### Daily
- Check application status: `docker-compose ps`
- Monitor logs for errors: `docker-compose logs crms-frontend`

### Weekly
- Review resource usage: `docker stats`
- Backup `.env` and configurations

### Monthly
- Update Docker: `docker pull node:20-alpine`
- Rebuild images: `docker-compose build --no-cache`
- Security updates: `docker system prune -a`

---

## Support and Resources

### Documentation Files

- **README.md** - Project overview and quick start
- **DOCKER_DEPLOYMENT_GUIDE.md** - Detailed deployment guide
- **docker-compose.yml** - Production configuration
- **docker-compose.dev.yml** - Development configuration

### Common Commands Reference

| Command | Purpose |
|---------|---------|
| `docker-compose up -d` | Start application in background |
| `docker-compose stop` | Stop containers |
| `docker-compose down` | Stop and remove containers |
| `docker-compose logs -f` | View live logs |
| `docker-compose ps` | Show container status |
| `docker-compose build --no-cache` | Rebuild image |
| `docker-compose exec crms-frontend sh` | Access container shell |

### Useful Links

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Troubleshooting Guide](https://docs.docker.com/config/containers/logging/)

### Getting Help

1. Check logs: `docker-compose logs crms-frontend`
2. Verify Docker/Compose installation
3. Review environment configuration
4. Check Docker system resources
5. Consult team documentation

---

## Quick Reference

### Production Deployment

```bash
# 1. Setup (one time)
git clone <repo>
cd carrental-frontend-main
cp .env.example .env

# 2. Deploy
docker-compose up -d

# 3. Verify
docker-compose ps
curl http://localhost:3000

# 4. Monitor
docker-compose logs -f crms-frontend

# 5. Stop (when needed)
docker-compose down
```

### Deployment Script Usage

**Windows:**
```cmd
deploy.bat start    # Start
deploy.bat stop     # Stop
deploy.bat restart  # Restart
deploy.bat logs     # View logs
deploy.bat rebuild  # Rebuild
```

**Linux/macOS:**
```bash
./deploy.sh start   # Start
./deploy.sh stop    # Stop
./deploy.sh restart # Restart
./deploy.sh logs    # View logs
./deploy.sh rebuild # Rebuild
```

---

## Summary

The CRMS Frontend is now ready for Docker deployment. The admin team can:

✅ Deploy with one command: `docker-compose up -d`
✅ Monitor with: `docker-compose logs -f`
✅ Stop with: `docker-compose down`
✅ Restart with: `docker-compose restart`

For additional information, refer to the individual documentation files or use deployment scripts for guided deployment.

---

**Document Version:** 1.0
**Last Updated:** November 17, 2025
