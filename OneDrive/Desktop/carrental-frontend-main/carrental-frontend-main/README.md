# CRMS Frontend - Car Rental Management System

A modern React + Vite frontend application for the Car Rental Management System (CRMS). This application provides an admin interface for managing car rentals with features including user authentication, dashboard analytics, and rental management.

## Features

- **React 19** - Latest React framework
- **Vite** - Lightning-fast build tool and dev server
- **React Router** - Client-side routing
- **Axios** - HTTP client for API integration
- **ESLint** - Code quality and style enforcement
- **Docker & Docker Compose** - Containerized deployment

## Getting Started

### Prerequisites

- Node.js 18+ or Docker/Docker Compose
- npm or yarn package manager
- Git

### Local Development

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Start development server:**
   ```bash
   npm run dev
   ```

3. **Open in browser:**
   - Navigate to `http://localhost:5173`

### Production Build

1. **Build the application:**
   ```bash
   npm run build
   ```

2. **Preview production build:**
   ```bash
   npm run preview
   ```

## Docker Deployment

### Quick Start with Docker Compose

Deploy the entire application with a single command:

```bash
docker-compose up -d
```

Access the application at `http://localhost:3000`

### Development with Docker

Run the development environment:

```bash
docker-compose -f docker-compose.dev.yml up
```

Access at `http://localhost:5173`

### Common Docker Commands

- **View logs:** `docker-compose logs -f crms-frontend`
- **Stop containers:** `docker-compose down`
- **Rebuild image:** `docker-compose build --no-cache`
- **Execute shell:** `docker-compose exec crms-frontend sh`

For detailed Docker deployment guide, see [DOCKER_DEPLOYMENT_GUIDE.md](./DOCKER_DEPLOYMENT_GUIDE.md)

## Project Structure

```
carrental-frontend/
├── src/
│   ├── components/    # Reusable React components
│   ├── pages/         # Page components (Dashboard, Login, Signup)
│   ├── assets/        # Static assets
│   ├── App.jsx        # Main app component
│   ├── main.jsx       # Application entry point
│   └── index.css      # Global styles
├── public/            # Public static files
├── Dockerfile         # Production Docker image
├── Dockerfile.dev     # Development Docker image
├── docker-compose.yml # Production compose configuration
├── docker-compose.dev.yml # Development compose configuration
├── vite.config.js     # Vite configuration
├── eslint.config.js   # ESLint configuration
└── package.json       # Dependencies and scripts
```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run lint` - Run ESLint
- `npm run preview` - Preview production build

## Configuration

### Environment Variables

Create a `.env` file based on `.env.example`:

```env
VITE_API_URL=http://localhost:8080
NODE_ENV=production
```

## Pages

- **Login** - User authentication page
- **Signup** - New user registration
- **Dashboard** - Main admin dashboard

## API Integration

The application communicates with a backend API. Configure the API URL in `.env`:

```env
VITE_API_URL=http://your-backend-api.com
```

## Development Technologies

- **React Compiler** - Can be enabled for advanced optimization
- **Babel/SWC** - Fast Refresh support
- **TypeScript Ready** - Compatible with TypeScript integration

For TypeScript integration, refer to the [Vite React TypeScript template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts)

## Git Integration

The project is configured for Git version control. All Docker and containerization files are tracked.

```bash
git add .
git commit -m "Add Docker and Docker Compose configuration"
git push origin main
```

## Support

For issues, questions, or contributions, please refer to the project's issue tracker or documentation.
