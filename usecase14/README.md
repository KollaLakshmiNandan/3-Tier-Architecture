# Use Case 14: Canary or Blue-Green Deployment

## Objective
Deploy a new application version with controlled exposure, verify its health, switch production-like traffic, and demonstrate a quick rollback.

## Strategy
This lab uses blue-green deployment on Kubernetes. The blue version represents the stable release, and the green version represents the new release. A Kubernetes Service selects which version receives traffic.

## Architecture
- Blue Deployment: stable application version.
- Green Deployment: new application version.
- Kubernetes Service: routes requests to the selected version.
- Verification scripts: check responses before and after switching traffic.

## Implementation Steps
1. Inspect the Kubernetes cluster and existing resources.
2. Deploy the blue and green application versions.
3. Verify both versions respond correctly.
4. Route Service traffic to green.
5. Verify the active version through the Service endpoint.
6. Roll back traffic to blue and verify recovery.
7. Save actual test outputs as evidence.

## Success Criteria
- Both versions can be deployed and identified.
- The Service can switch between blue and green.
- The active version can be verified through HTTP responses.
- Rollback restores traffic to the previous version.
- Evidence and instructions are documented.

## Scope and Limitations
This lab demonstrates blue-green switching, not weighted canary traffic. Weighted routing requires compatible ingress/controller support or another traffic-management component.
