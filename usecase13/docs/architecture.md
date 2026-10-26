# Use Case 13: Architecture

## Purpose
Explain how Kyverno enforces the container image-tag policy.

## Components
- Developer: submits a Kubernetes Pod manifest.
- Kubernetes API Server: receives the request.
- Kyverno Admission Controller: evaluates the Pod.
- ClusterPolicy: defines the validation rule.

## Request Flow
1. Developer submits a Pod manifest.
2. Kubernetes API Server receives the request.
3. Kyverno evaluates the Pod against the policy.
4. Pods using nginx:latest are rejected.
5. Pods using nginx:1.28 are allowed.

## Architecture Diagram

Developer
   |
   v
Kubernetes API Server
   |
   v
Kyverno Admission Controller
   |
   v
disallow-latest-tag ClusterPolicy
   |
   +---- nginx:latest ----> Rejected
   |
   +---- nginx:1.28 ------> Allowed

## Enforcement
The policy uses validationFailureAction: Enforce.

## Test Method
Both tests use server-side dry runs. No persistent test Pods are created.

## Limitations
- The policy targets Pods using the latest image tag.
- Explicit image tags can still be mutable.
- The ClusterPolicy API is deprecated in the installed Kyverno version.
