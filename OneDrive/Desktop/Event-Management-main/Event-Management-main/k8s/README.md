Kubernetes deployment for Event-Management

This folder contains Kubernetes manifests to deploy the application components (MySQL, backend, frontend) into a Kubernetes cluster.

Quick steps (local development - Minikube):

1. Start a local cluster (minikube):

   ```powershell
   minikube start
   ```

2. Build the images and load them into Minikube (or push to a registry and update images in the manifests):

   ```powershell
   # from repo root
   docker build -t event-backend:latest ./Backend
   docker build -t event-frontend:latest ./frontend

   # If using minikube, load images into the cluster
   minikube image load event-backend:latest
   minikube image load event-frontend:latest
   ```

   If you use Kind, use `kind load docker-image` instead.

3. Apply manifests:

   ```powershell
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/mysql-secret.yaml
   kubectl apply -f k8s/mysql-pvc.yaml
   kubectl apply -f k8s/mysql-deployment.yaml
   kubectl apply -f k8s/backend-deployment.yaml
   kubectl apply -f k8s/frontend-deployment.yaml
   ```

4. Verify resources:

   ```powershell
   kubectl get all -n event-management
   kubectl logs -n event-management deployment/backend -f
   kubectl logs -n event-management deployment/frontend -f
   ```

5. Access frontend:

   - If using Minikube: `minikube service frontend -n event-management --url`
   - If using NodePort (manifests default): browse to `http://<node-ip>:30080` or `http://localhost:30080` (if kube exposes it locally).

Notes and production considerations:

- The manifests use `event-backend:latest` and `event-frontend:latest` images. For production, push images to a container registry and update the manifests to reference the registry (`myregistry.io/event-backend:tag`).
- The MySQL password is stored in a Kubernetes Secret (base64 for `root` in `mysql-secret.yaml`). Change this to a secure password for production.
- The PVC requests 1Gi. Make sure your cluster has a default StorageClass or set `storageClassName` in `mysql-pvc.yaml`.
- Consider adding an Ingress (with TLS), readiness/liveness HTTP probes (if you add an actuator endpoint), and resource limits/requests.

CI/CD with GitHub Actions
-------------------------

This repository includes a GitHub Actions workflow at `.github/workflows/ci-cd.yml` that will:

- Build and push the backend and frontend Docker images to GitHub Container Registry (GHCR) on pushes to `main`.
- Optionally deploy to a Kubernetes cluster if you add a repository secret named `KUBECONFIG` containing your kubeconfig file contents.

How to enable automatic deploys:

1. Ensure the `packages: write` permission is enabled for the workflow (the workflow file already requests it).
2. If you want the workflow to deploy to your cluster, add a repository secret named `KUBECONFIG` (the raw kubeconfig YAML). The workflow will write this file and use `kubectl apply -f k8s/`.
3. The workflow pushes images to `ghcr.io/<OWNER>/event-backend:<sha>` and `ghcr.io/<OWNER>/event-frontend:<sha>`. Make sure GHCR is enabled for your account/org and that the repo has `packages: write` permissions for the workflow.

Security note: storing kubeconfig in repo secrets is common for CI deployments, but ensure the token/context in the kubeconfig has limited privileges (use a service account with a minimal RBAC role if possible).

