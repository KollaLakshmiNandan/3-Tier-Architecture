# Use Case 15 — Multi-Environment Promotion Validation

## Objective
Validate Helm rendering and confirm consistent application artifact
references across DEV, QA, STAGE, and PROD-LIKE.

## Validation results
- Helm lint passed for all four environments.
- Helm template completed successfully for all four environments.
- Frontend image reference is identical across all environments.
- Backend image reference is identical across all environments.
- No REPLACE_WITH_ digest placeholders remain in the checked values
  and rendered manifests.

## Replica configuration

| Environment | Frontend replicas | Backend replicas |
|---|---:|---:|
| DEV | 1 | 1 |
| QA | 1 | 2 |
| STAGE | 2 | 2 |
| PROD-LIKE | 2 | 3 |

## Artifact references currently configured

Frontend:
devopshub-frontend@sha256:fcd7207178ba39d73f6150b7c54510bd927b0b63d111fca81f164fcd76534c75

Backend:
devopshub-backend@sha256:2a7a137cf789991fac81c5e793b49cca40af63574c4983ff41be2bd751baaddb

## Outstanding checks
- Confirm the frontend API proxy targets the stable backend Service.
- Confirm images are available to the target Kubernetes cluster.
- Confirm environment-specific database Secrets exist with the required keys.
- Validate rollback procedure and approval gates before deployment.

## Deployment status
No deployment performed as part of these validation steps.
