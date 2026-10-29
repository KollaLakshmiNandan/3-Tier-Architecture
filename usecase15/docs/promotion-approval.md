# Use Case 15: Environment Promotion Approval Gates

## Objective
Promote the same immutable frontend and backend image digests through
Dev, QA, Stage, and Prod-like without rebuilding the application.

## Promotion Flow

Dev -> QA -> Stage -> Prod-like

## Approval Matrix

| Environment | Required validation | Approval gate |
|---|---|---|
| Dev | Helm rendering, configuration validation, health-check configuration | Developer validation |
| QA | Dev validation completed, QA configuration reviewed, tests passed | QA approval |
| Stage | QA validation completed, rendered differences reviewed, deployment readiness checked | Release owner approval |
| Prod-like | Stage validation completed, image digests verified, rollback plan reviewed | Explicit release approval |

## Promotion Rules

1. Keep the frontend and backend image digests identical across environments.
2. Change only approved environment-specific configuration during promotion.
3. Keep database credentials in Kubernetes Secrets; never commit secret values.
4. Do not promote if rendering, testing, or required approvals fail.
5. Record the approver, approval time, image digests, and validation evidence.
6. Prod-like promotion requires an explicit approval before deployment.

## Current Evidence

- Rendered manifests exist for Dev, QA, Stage, and Prod-like.
- Dev vs QA, QA vs Stage, and Stage vs Prod-like diff files have been generated.
- Helm rendering has been validated.
- These checks do not by themselves prove that deployments or application tests passed.

## Deployment Status

No deployment is performed as part of this documentation step.
