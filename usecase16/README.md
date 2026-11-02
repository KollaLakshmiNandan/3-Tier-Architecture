# Use Case 16 – Detect and Fix Configuration Drift

## 1. Project Overview

An enterprise-style Claims Management Application with automated configuration drift detection and remediation using Kubernetes, Helm, Argo CD, and Terraform.

The objective is to identify differences between the desired configuration and the actual infrastructure state, detect unauthorized configuration changes, and restore the system to its intended configuration.

## 2. Technology Stack

| Component | Technology |
|---|---|
| Frontend | React, Vite |
| Backend | Python, Flask |
| Database | PostgreSQL |
| Containerization | Docker |
| Container Orchestration | Kubernetes |
| Package Management | Helm |
| GitOps | Argo CD |
| Infrastructure as Code | Terraform |
| CI/CD | GitLab CI/CD |
| Security Scanning | Trivy |
| Source Code Management | GitLab |

## 3. Application Architecture

The application follows a three-tier architecture.

- **Presentation Tier:** React frontend.
- **Application Tier:** Python Flask backend.
- **Database Tier:** PostgreSQL database.

All three tiers run as separate Kubernetes deployments and communicate through Kubernetes ClusterIP services.

### Architecture Flow

```text
                 GitLab Repository
                        |
                        v
                 GitLab CI/CD
                        |
             Validation / Testing
                        |
                 Docker Builds
                        |
                  Trivy Scan
                        |
                        v
                  Kubernetes
                        |
          +-------------+-------------+
          |             |             |
          v             v             v
       Frontend      Backend      PostgreSQL
        React         Flask        Database
```

## 4. Configuration Drift Management

### 4.1 Desired State

The desired configuration is maintained in GitLab and represented through the Helm chart and Terraform configuration.

### 4.2 Actual State

The actual configuration represents the resources currently running in the Kubernetes cluster.

### 4.3 Drift Detection

Argo CD continuously compares the Git-defined desired configuration with live Kubernetes resources.

Terraform detects differences between its configuration, Terraform state, and the actual state of Terraform-managed resources.

### 4.4 Automatic Remediation

Argo CD automated synchronization and self-healing restore managed Kubernetes resources to their desired Git configuration.

Terraform identifies configuration drift through `terraform plan`. Approved changes are applied using `terraform apply`.

## 5. Kubernetes Environment

Namespace:

`usecase16-lab`

Application deployments:

- claims-frontend
- claims-backend
- postgres

Services:

- claims-frontend – Port 8080
- claims-backend – Port 5000
- postgres – Port 5432

Expected replica configuration:

| Component | Desired Replicas |
|---|---:|
| Frontend | 2 |
| Backend | 2 |
| PostgreSQL | 1 |

## 6. Helm Deployment

Validate the Helm chart:

```bash
helm lint usecase16/helm
```

Render Kubernetes manifests:

```bash
helm template usecase16 usecase16/helm \
  --namespace usecase16-lab
```

Deploy the application:

```bash
helm upgrade --install usecase16 usecase16/helm \
  --namespace usecase16-lab \
  --create-namespace
```

## 7. Terraform Operations

Initialize Terraform:

```bash
terraform -chdir=usecase16/terraform init
```

Validate configuration:

```bash
terraform -chdir=usecase16/terraform validate
```

Review infrastructure changes:

```bash
terraform -chdir=usecase16/terraform plan
```

Apply approved changes:

```bash
terraform -chdir=usecase16/terraform apply
```

Terraform manages the configuration baseline ConfigMap:

`usecase16-drift-baseline`

The baseline records the expected environment and replica configuration.

## 8. Configuration Drift Simulation

### Scenario 1: Kubernetes Replica Drift

Initial desired backend replicas: 2.

Manually increase the actual replica count to 3:

```bash
kubectl scale deployment claims-backend \
  --replicas=3 \
  -n usecase16-lab
```

Argo CD detects the difference between the Git-defined desired state and the live Kubernetes configuration.

With self-healing enabled, Argo CD restores the backend deployment to 2 replicas.

### Scenario 2: Terraform Configuration Drift

Initial desired environment: `dev`.

Manually modify the Terraform-managed ConfigMap:

```bash
kubectl patch configmap usecase16-drift-baseline \
  -n usecase16-lab \
  --type merge \
  -p '{"data":{"environment":"staging"}}'
```

Detect the drift:

```bash
terraform -chdir=usecase16/terraform plan
```

Terraform identifies the difference:

```text
environment = "staging" -> "dev"

Plan: 0 to add, 1 to change, 0 to destroy.
```

Restore the intended configuration:

```bash
terraform -chdir=usecase16/terraform apply
```

The ConfigMap environment is restored to `dev`.

## 9. Argo CD GitOps Integration

Argo CD application manifest:

`usecase16/argocd/application.yaml`

Application name:

`usecase16-dev`

Git repository:

`https://gitlab.com/midhtech-group3/3-tier-architecture.git`

Target branch:

`feature/usecase16`

Helm chart path:

`usecase16/helm`

Automated synchronization, pruning, and self-healing are configured.

Argo CD continuously monitors the Git repository and reconciles the live Kubernetes resources with the desired configuration.

## 10. GitLab CI/CD Pipeline

The root `.gitlab-ci.yml` includes the Use Case 16 pipeline configuration.

Pipeline configuration:

`usecase16/.gitlab-ci.yml`

### Pipeline Stages

| Stage | Validation / Job |
|---|---|
| Validate | Helm chart validation |
| Validate | Terraform validation |
| Validate | Shell script validation |
| Test | Backend unit tests |
| Build | Frontend production build |
| Build | Docker image builds |
| Security | Trivy image scanning |

The pipeline executes using the configured GitLab macOS Shell runner.

## 11. Verification and Test Results

### Kubernetes Verification

The deployed application was verified successfully.

| Component | Expected | Actual |
|---|---:|---:|
| Backend | 2 | 2 |
| Frontend | 2 | 2 |
| PostgreSQL | 1 | 1 |

All five application pods were running with zero restarts at the time of verification.

### Argo CD Verification

Application: `usecase16-dev`

Sync Status: Synced

Health Status: Healthy

### Drift Detection Verification

- Backend replica drift from 2 to 3 was corrected by Argo CD self-healing.
- Terraform detected the ConfigMap environment drift from `dev` to `staging`.
- Terraform successfully restored the environment to `dev` after approval.

### CI/CD Verification

All GitLab pipeline jobs passed during the final pipeline execution.

## 12. Project Directory Structure

```text
usecase16/
├── argocd/
│   └── application.yaml
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   ├── test_app.py
│   └── Dockerfile
├── database/
│   └── init.sql
├── frontend/
│   ├── src/
│   ├── index.html
│   ├── package.json
│   ├── package-lock.json
│   ├── vite.config.js
│   ├── Dockerfile
│   └── nginx/
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── files/
│   └── templates/
├── scripts/
│   ├── simulate-drift.sh
│   └── verify-state.sh
├── terraform/
│   ├── providers.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
├── .env.example
├── .gitignore
├── .gitlab-ci.yml
└── README.md
```

## 13. Project Outcome

The project successfully demonstrates:

- Deployment of a three-tier application on Kubernetes.
- Containerization and Helm-based application deployment.
- GitOps-based configuration monitoring using Argo CD.
- Automatic correction of Kubernetes replica drift.
- Terraform-based detection of configuration drift.
- Terraform-based remediation after approval.
- Automated CI/CD validation, testing, Docker builds, and security scanning.

**Final Result:** The application was deployed successfully, configuration drift was deliberately introduced and detected, and the desired configuration was restored using Argo CD and Terraform.

## 14. Screenshots and Evidence

Add project execution screenshots under `docs/screenshots/`.

Recommended evidence:

1. Kubernetes pods, deployments, and services.
2. Argo CD application showing Synced and Healthy.
3. Argo CD replica drift correction.
4. Terraform plan showing the detected drift.
5. Terraform apply showing successful remediation.
6. GitLab pipeline showing all jobs passed.

---

**Project:** Use Case 16 – Detect and Fix Configuration Drift

**Repository Branch:** `feature/usecase16`