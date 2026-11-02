
# Use Case 16 - Detect and Fix Configuration Drift

## 1. Project Overview

An enterprise-style Claims Management Application with automated configuration drift detection and remediation using Kubernetes, Helm, Argo CD, and Terraform.

The objective is to identify differences between the desired configuration and the actual infrastructure state and restore the desired configuration.

## 2. Architecture

- Frontend: React and Vite
- Backend: Python Flask
- Database: PostgreSQL
- Containers: Docker
- Container Orchestration: Kubernetes
- Package Management: Helm
- GitOps: Argo CD
- Infrastructure as Code: Terraform
- CI/CD: GitLab CI
- Security Scanning: Trivy

## 3. Application Architecture

React Frontend -> Flask Backend -> PostgreSQL Database

The application runs inside Kubernetes using separate deployments and services.

## 4. Configuration Drift Management

### Desired State

The desired configuration is maintained in GitLab.

### Drift Detection

Argo CD continuously compares the Git configuration with the live Kubernetes resources.

### Automatic Remediation

Argo CD automated sync and self-heal restore resources to the desired Git configuration.

### Terraform Drift

Terraform manages a baseline ConfigMap and can detect out-of-band changes to that resource through Terraform plan.

## 5. Kubernetes Namespace

usecase16-lab

## 6. Helm Deployment

Validate the Helm chart:

```bash
helm lint usecase16/helm
```

Deploy:

```bash
helm upgrade --install usecase16 usecase16/helm \
  --namespace usecase16-lab \
  --create-namespace
```

## 7. Terraform Operations

Initialize:

```bash
terraform -chdir=usecase16/terraform init
```

Validate:

```bash
terraform -chdir=usecase16/terraform validate
```

Review changes:

```bash
terraform -chdir=usecase16/terraform plan
```

Apply:

```bash
terraform -chdir=usecase16/terraform apply
```

## 8. Drift Simulation

Run:

```bash
bash usecase16/scripts/simulate-drift.sh
```

Verify:

```bash
bash usecase16/scripts/verify-state.sh
```

## 9. Argo CD

Argo CD application manifest:

argocd/application.yaml

Application name:

usecase16-dev

Automated synchronization and self-healing are configured.

## 10. CI/CD Pipeline

The GitLab pipeline validates:

- Helm chart
- Terraform configuration
- Shell scripts
- Backend unit tests
- Frontend production build
- Docker image builds
- Trivy image scans

## 11. Expected Outcome

- Application runs in Kubernetes.
- Configuration changes can be detected.
- Terraform identifies drift in Terraform-managed resources.
- Argo CD detects differences between Git and live Kubernetes resources.
- Argo CD self-heal restores the desired application configuration.

