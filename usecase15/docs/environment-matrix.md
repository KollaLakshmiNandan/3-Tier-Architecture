
# Use Case 15: Multi-Environment Promotion

## 1. Objective

Promote the same application artifact through DEV, QA, STAGE, and
PROD-LIKE environments while keeping environment-specific configuration
intentional, controlled, and reviewable.

## 2. Environment Matrix

| Configuration | DEV | QA | STAGE | PROD-LIKE |
|---|---|---|---|---|
| Purpose | Developer validation | Functional testing | Release validation | Production-like validation |
| Namespace | claims-dev | claims-qa | claims-stage | claims-prod-like |
| Helm release | claims-app | claims-app | claims-app | claims-app |
| Application image | Same immutable digest | Same immutable digest | Same immutable digest | Same immutable digest |
| Backend replicas | 1 | 2 | 2 | 3 |
| Frontend replicas | 1 | 1 | 2 | 2 |
| Resource profile | Small | Medium | Medium | Higher |
| Secret reference | claims-dev-secret | claims-qa-secret | claims-stage-secret | claims-prod-like-secret |
| Promotion approval | Developer validation | QA approval | Release approval | Explicit approval |
| Rollback method | Restore previous values and image digest | Restore previous values and image digest | Restore previous values and image digest | Restore previous approved release |

## 3. Settings That Must Stay Consistent

- Application image digest.
- Application version being promoted.
- Container ports and application interfaces.
- Health-check behavior.
- Common Kubernetes labels and selectors.
- Application configuration schema.

## 4. Settings Allowed to Differ

- Namespace and environment name.
- Frontend and backend replica counts.
- CPU and memory requests and limits.
- Secret references.
- Environment-specific non-secret configuration.
- Approval requirements and promotion records.

## 5. Security Rules

- Never commit passwords, tokens, or database credentials.
- Store only secret references in the values files.
- Keep credentials separate for each environment.
- Do not use mutable image tags as proof of artifact identity.
- Use an immutable image digest to verify promotion consistency.

## 6. Validation Requirements

- Render Helm manifests for every environment.
- Confirm the same image digest is used everywhere.
- Compare rendered manifests and review expected differences.
- Record promotion approvals.
- Document rollback steps and retain verification evidence.

## 7. Scope Boundary

This use case focuses on environment design, Helm values,
configuration comparison, promotion controls, and rollback evidence.

It does not create a separate deployment pipeline for every environment.
