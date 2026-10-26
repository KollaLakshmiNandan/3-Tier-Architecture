# Use Case 13: Policy Tests

## Purpose
These tests verify that Kyverno rejects Pods using the latest image tag and accepts Pods using an explicit version tag.

## Test Files
- `compliant-pod.yaml`: uses `nginx:1.28`; expected to be accepted.
- `non-compliant-pod.yaml`: uses `nginx:latest`; expected to be rejected.

## Prerequisites
- Kubernetes cluster is running.
- Kyverno Pods are ready.
- The `disallow-latest-tag` ClusterPolicy is ready.

## Test 1: Verify Rejection
Run from the repository root:

```bash
kubectl create --dry-run=server -f usecase13/tests/non-compliant-pod.yaml -o yaml
```

Expected: the API request is rejected by the `disallow-latest-tag` policy.

## Test 2: Verify Acceptance
```bash
kubectl create --dry-run=server -f usecase13/tests/compliant-pod.yaml -o yaml
```

Expected: the API server accepts the request and returns the Pod YAML.

## Important
These commands use server-side dry-run. They do not create persistent Pods.
If a test result differs from the expected result, check the Kubernetes context, Kyverno readiness, and policy status.
