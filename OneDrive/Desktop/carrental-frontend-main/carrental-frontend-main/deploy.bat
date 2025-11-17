@echo off
REM CRMS Frontend - Docker Deployment Script (Windows)
REM Usage: deploy.bat [start|stop|restart|rebuild|logs|status|help]

setlocal enabledelayedexpansion

set "PROJECT_NAME=crms-frontend"
set "COMPOSE_FILE=docker-compose.yml"
set "ENV_FILE=.env"

REM Function to print colored output (using echo with formatting)
:print_status
echo [*] %~1
goto :eof

:print_error
echo [ERROR] %~1
goto :eof

:print_warning
echo [WARNING] %~1
goto :eof

REM Check if Docker is installed
:check_docker
where docker >nul 2>nul
if errorlevel 1 (
    call :print_error "Docker is not installed. Please install Docker Desktop for Windows."
    exit /b 1
)
for /f "tokens=*" %%i in ('docker --version') do (
    call :print_status "Docker is installed: %%i"
)
goto :eof

REM Check if Docker Compose is installed
:check_docker_compose
where docker-compose >nul 2>nul
if errorlevel 1 (
    call :print_error "Docker Compose is not installed. Please install Docker Desktop for Windows."
    exit /b 1
)
for /f "tokens=*" %%i in ('docker-compose --version') do (
    call :print_status "Docker Compose is installed: %%i"
)
goto :eof

REM Check environment file
:check_env_file
if not exist "%ENV_FILE%" (
    if exist ".env.example" (
        call :print_warning "Environment file not found. Creating from .env.example..."
        copy .env.example "%ENV_FILE%"
        call :print_status "Created %ENV_FILE%. Please review and update if needed."
    ) else (
        call :print_error "Neither %ENV_FILE% nor .env.example found."
        exit /b 1
    )
)
goto :eof

REM Start deployment
:start_deployment
call :print_status "Starting %PROJECT_NAME%..."
call :check_env_file
docker-compose -f "%COMPOSE_FILE%" up -d
if errorlevel 1 exit /b 1
call :print_status "%PROJECT_NAME% started successfully!"
call :print_status "Application URL: http://localhost:3000"
call :print_status "Run 'deploy.bat logs' to view logs"
goto :eof

REM Stop deployment
:stop_deployment
call :print_status "Stopping %PROJECT_NAME%..."
docker-compose -f "%COMPOSE_FILE%" down
if errorlevel 1 exit /b 1
call :print_status "%PROJECT_NAME% stopped successfully!"
goto :eof

REM Restart deployment
:restart_deployment
call :print_status "Restarting %PROJECT_NAME%..."
call :stop_deployment
call :start_deployment
goto :eof

REM Rebuild deployment
:rebuild_deployment
call :print_status "Rebuilding %PROJECT_NAME% image..."
docker-compose -f "%COMPOSE_FILE%" build --no-cache
if errorlevel 1 exit /b 1
call :print_status "Image rebuilt successfully!"
call :print_status "Run 'deploy.bat start' to deploy the new image"
goto :eof

REM View logs
:view_logs
call :print_status "Viewing logs for %PROJECT_NAME%..."
docker-compose -f "%COMPOSE_FILE%" logs -f crms-frontend
goto :eof

REM Show status
:show_status
call :print_status "Status of %PROJECT_NAME%:"
docker-compose -f "%COMPOSE_FILE%" ps
goto :eof

REM Show help
:show_help
echo CRMS Frontend Docker Deployment Script
echo.
echo Usage: %0 [COMMAND]
echo.
echo Commands:
echo   start      - Start the application (default^)
echo   stop       - Stop the application
echo   restart    - Restart the application
echo   rebuild    - Rebuild the Docker image
echo   logs       - View application logs
echo   status     - Show container status
echo   help       - Show this help message
echo.
goto :eof

REM Main script logic
if "%1"=="" (
    set "COMMAND=start"
) else (
    set "COMMAND=%1"
)

call :check_docker
call :check_docker_compose

if /i "%COMMAND%"=="start" (
    call :start_deployment
) else if /i "%COMMAND%"=="stop" (
    call :stop_deployment
) else if /i "%COMMAND%"=="restart" (
    call :restart_deployment
) else if /i "%COMMAND%"=="rebuild" (
    call :rebuild_deployment
) else if /i "%COMMAND%"=="logs" (
    call :view_logs
) else if /i "%COMMAND%"=="status" (
    call :show_status
) else if /i "%COMMAND%"=="help" (
    call :show_help
) else (
    call :print_error "Unknown command: %COMMAND%"
    call :show_help
    exit /b 1
)

endlocal
