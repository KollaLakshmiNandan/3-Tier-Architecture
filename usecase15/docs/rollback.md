# Use Case 15: Environment-Specific Rollback Procedure

## Objective
Restore a previously validated application version in the affected environment
without changing the other environments.

## Rollback Principles

1. Identify the affected environment and its current Helm release.
2. Record the current image digests, release revision, and incident details.
3. Select the last known-good application version and environment configuration.
4. Verify the target image digests and required Secret references.
5. Roll back only the affected environment.
6. Validate application health and record the rollback evidence.
7. Investigate the incident before attempting promotion again.

## Environment Rollback Matrix

| Environment | Namespace | Helm release | Rollback scope |
|---|---|---|---|
| Dev | claims-dev | claims-app | Restore the last known-good Dev revision |
| QA | claims-qa | claims-app | Restore the last known-good QA revision |
| Stage | claims-stage | claims-app | Restore the last known-good Stage revision |
| Prod-like | claims-prod-like | claims-app | Restore the last approved Prod-like revision |

## Procedure

### 1. Inspect release history

Run for the affected environment, replacing the namespace as required:

```bash
helm history claims-app -n claims-dev
```

### 2. Review the target revision

Identify the last known-good revision from the release history.
Confirm the image digests and values are appropriate for that environment.

### 3. Perform rollback only after authorization

Example for Dev:

```bash
helm rollback claims-app <REVISION> -n claims-dev
```

Replace `<REVISION>` with the verified revision number.
Do not run this example until the target revision is confirmed and rollback is authorized.

### 4. Validate the result

```bash
kubectl get deployments, pods -n claims-dev
kubectl rollout status deployment/claims-app-backend -n claims-dev
kubectl rollout status deployment/claims-app-frontend -n claims-dev
```

Confirm the expected image digests, replica counts, health checks, configuration,
and application behavior.

### 5. Record evidence

Record:
- Environment and namespace
- Incident or reason for rollback
- Previous and restored release revisions
- Frontend and backend image digests
- Approval and execution timestamps
- Health-check and application validation results
- Follow-up actions

## Environment Isolation

A rollback in one namespace must not change the other environments.
Promotions remain blocked until the incident is understood and the required
validation and approvals have passed.

## Current Status

This document defines the rollback procedure only.
No rollback or deployment has been executed as part of this documentation step.
