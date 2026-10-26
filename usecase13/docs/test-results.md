# Use Case 13: Test Results

## Objective
Verify that the Kyverno policy rejects Pods using the latest image tag and accepts Pods using an explicit version tag.

## Test Environment
- Kubernetes: Docker Desktop cluster
- Policy engine: Kyverno
- Policy: disallow-latest-tag
- Test method: Kubernetes server-side dry-run

## Results

### Test 1: Reject latest tag
- Manifest: `usecase13/tests/non-compliant-pod.yaml`
- Image: `nginx:latest`
- Expected: rejected by Kyverno
- Observed: rejected by `disallow-latest-tag`, rule `require-image-tag`
- Result: PASS
- Evidence: `usecase13/evidence/03-latest-tag-rejected.txt`

### Test 2: Accept explicit version tag
- Manifest: `usecase13/tests/compliant-pod.yaml`
- Image: `nginx:1.28`
- Expected: accepted by the API server
- Evidence: `usecase13/evidence/04-versioned-tag-accepted.txt`
- Result: confirm after reviewing the saved command output

### Kyverno readiness
- Four Kyverno controller Pods were observed Running and Ready (`1/1`).
- Evidence: `usecase13/evidence/01-kyverno-pods.txt`

### Policy readiness
- Policy: `disallow-latest-tag`
- Ready: `True`
- Validation rules: `1`
- Evidence: `usecase13/evidence/02-policy-status.txt`

## Test Safety
Both test requests use server-side dry-run. They validate admission behavior without creating persistent test Pods.

## Limitations
- The policy blocks the latest image tag but does not guarantee that other tags are immutable.
- The current ClusterPolicy API is deprecated in the installed Kyverno version; migration is a future improvement.
