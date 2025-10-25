# Run the full app with Docker (frontend + backend)

This project contains a Spring Boot backend and a Vite React frontend. Use Docker Compose to build and run both together.

Quick steps (from the workspace root `Carrental-fullstack`):

1. Build and start both services:

```powershell
docker compose up --build
```

2. Open the app in your browser:

- Frontend: http://localhost:3000
- Backend API: http://localhost:8081

Notes and tips:
- The backend Dockerfile is at `carrental-backend-main/carrental-backend-main/Dockerfile` (already present).
- The frontend Dockerfile is at `carrental-frontend-main/carrental-frontend-main/Dockerfile`.
- Locally, for development, you can run the frontend dev server from the frontend folder:

```powershell
cd carrental-frontend-main\carrental-frontend-main
npm install
npm run dev    # or npm start (start maps to vite)
```

and the backend from its folder:

```powershell
cd carrental-backend-main\carrental-backend-main
./mvnw spring-boot:run
```

- If your frontend expects to call the backend at a particular origin, ensure API URLs are configured correctly before building the frontend (set env vars or change the base URL in your code). For production you typically build the frontend with the correct API URL baked into the static files.
