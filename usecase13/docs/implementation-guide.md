# Use Case 13: Implementation Guide

## 1. Overview
This guide explains how to install Kyverno, deploy the image-tag policy, and verify its behavior.

## 2. Prerequisites
- Docker Desktop with Kubernetes enabled.
- kubectl configured to access the cluster.
- Helm installed.
- Git installed.

## 3. Verify the Environment
Check the Kubernetes context:

```bash
kubectl config current-context
kubectl get nodes
helm version
```

Confirm that you are using the intended local Kubernetes cluster before continuing.

## 4. Install Kyverno
Add the official Kyverno Helm repository and update it:

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
```

Install Kyverno in its own namespace:

```bash
helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
```

If Kyverno is already installed, do not run the install command again. Check the existing release instead:

```bash
helm list -n kyverno
kubectl get pods -n kyverno
```

Wait until the Kyverno controller Pods are Running and ready.

## 5. Deploy the Policy
The policy file is located at `usecase13/policies/disallow-latest-tag.yaml`.

Apply it to the current Kubernetes cluster:

```bash
kubectl apply -f usecase13/policies/disallow-latest-tag.yaml
kubectl get clusterpolicy disallow-latest-tag
```

The policy is configured with `validationFailureAction: Enforce`, so non-compliant Pod requests should be rejected.

## 6. Test the Policy
### Test A: Reject the latest tag

```bash
kubectl run test-latest --image=nginx:latest --restart=Never --dry-run=server -o yaml
```

Expected result: the Kubernetes API request is denied by the policy.

### Test B: Allow an explicit version tag

```bash
kubectl run test-pinned --image=nginx:1.28 --restart=Never --dry-run=server -o yaml
```

Expected result: the server-side dry run succeeds and returns the Pod YAML.

Both commands use `--dry-run=server`, so they validate the requests without creating persistent test Pods.

## 7. Troubleshooting
- If the Kubernetes context is incorrect, select the intended context before applying resources.
- If Kyverno Pods are not ready, inspect them with `kubectl describe pod -n kyverno POD_NAME` and `kubectl logs -n kyverno POD_NAME`.
- If the policy is not ready, inspect it with `kubectl describe clusterpolicy disallow-latest-tag`.
- If image pulls fail, inspect the Pod events and verify that the container registry is reachable.

## 8. Important Notes
- The policy blocks the `latest` tag; it does not prove that other tags are immutable.
- This implementation uses the `ClusterPolicy` API, which is deprecated in the installed Kyverno version. Consider migrating to the newer policy API in a future improvement.
- Run these commands only against the intended development cluster.
