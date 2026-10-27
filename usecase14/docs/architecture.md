# Use Case 14: Blue-Green Deployment Architecture

## Purpose
Demonstrate how Kubernetes can switch application traffic between a stable Blue deployment and a new Green deployment.

## Components
- Blue Deployment: runs the stable application version.
- Green Deployment: runs the new application version.
- Kubernetes Service: sends traffic to Pods selected by labels.
- Dedicated namespace: `usecase14-lab` keeps this lab separate from other workloads.

## Traffic Flow
1. Deploy Blue and verify its response.
2. Deploy Green and verify its response independently.
3. Update the Service selector to route traffic to Green.
4. Verify that the Service returns the Green version.
5. Roll back the Service selector to Blue.
6. Verify that traffic returns to Blue.

## Architecture Diagram

```text
                     Kubernetes Service
                             |
                    selects app version
                       /          \\
                      v            v
               Blue Deployment  Green Deployment
               Stable version   New version
                      |            |
                  Blue Pods     Green Pods
```

## Rollback
Rollback is performed by changing the Service selector back to the Blue deployment labels. Both deployments remain available during the demonstration.

## Scope
This lab demonstrates blue-green switching, not weighted canary traffic. Weighted traffic requires additional routing capabilities.
