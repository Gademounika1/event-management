#!/bin/bash
# CRMS Frontend - Docker Deployment Script
# Usage: ./deploy.sh [start|stop|restart|rebuild|logs]

set -e

PROJECT_NAME="crms-frontend"
COMPOSE_FILE="docker-compose.yml"
ENV_FILE=".env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    print_status "Docker is installed: $(docker --version)"
}

# Function to check if Docker Compose is installed
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    print_status "Docker Compose is installed: $(docker-compose --version)"
}

# Function to check environment file
check_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        print_warning "Environment file not found. Creating from .env.example..."
        if [ -f ".env.example" ]; then
            cp .env.example "$ENV_FILE"
            print_status "Created $ENV_FILE. Please review and update if needed."
        else
            print_error "Neither $ENV_FILE nor .env.example found."
            exit 1
        fi
    fi
}

# Function to start containers
start_deployment() {
    print_status "Starting $PROJECT_NAME..."
    check_env_file
    docker-compose -f "$COMPOSE_FILE" up -d
    print_status "$PROJECT_NAME started successfully!"
    print_status "Application URL: http://localhost:3000"
    print_status "Run './deploy.sh logs' to view logs"
}

# Function to stop containers
stop_deployment() {
    print_status "Stopping $PROJECT_NAME..."
    docker-compose -f "$COMPOSE_FILE" down
    print_status "$PROJECT_NAME stopped successfully!"
}

# Function to restart containers
restart_deployment() {
    print_status "Restarting $PROJECT_NAME..."
    stop_deployment
    start_deployment
}

# Function to rebuild images
rebuild_deployment() {
    print_status "Rebuilding $PROJECT_NAME image..."
    docker-compose -f "$COMPOSE_FILE" build --no-cache
    print_status "Image rebuilt successfully!"
    print_status "Run './deploy.sh start' to deploy the new image"
}

# Function to view logs
view_logs() {
    print_status "Viewing logs for $PROJECT_NAME..."
    docker-compose -f "$COMPOSE_FILE" logs -f crms-frontend
}

# Function to show status
show_status() {
    print_status "Status of $PROJECT_NAME:"
    docker-compose -f "$COMPOSE_FILE" ps
}

# Function to show help
show_help() {
    echo "CRMS Frontend Docker Deployment Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start      - Start the application (default)"
    echo "  stop       - Stop the application"
    echo "  restart    - Restart the application"
    echo "  rebuild    - Rebuild the Docker image"
    echo "  logs       - View application logs"
    echo "  status     - Show container status"
    echo "  help       - Show this help message"
    echo ""
}

# Main script logic
main() {
    check_docker
    check_docker_compose

    COMMAND="${1:-start}"

    case "$COMMAND" in
        start)
            start_deployment
            ;;
        stop)
            stop_deployment
            ;;
        restart)
            restart_deployment
            ;;
        rebuild)
            rebuild_deployment
            ;;
        logs)
            view_logs
            ;;
        status)
            show_status
            ;;
        help)
            show_help
            ;;
        *)
            print_error "Unknown command: $COMMAND"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
