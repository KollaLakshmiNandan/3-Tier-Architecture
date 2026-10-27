# Use Case 14: Implementation Guide

## 1. Prerequisites
- Docker Desktop Kubernetes is enabled.
- kubectl is configured for the intended cluster.
- The current Git branch is `feature/usecase14-blue-green-deployment`.

## 2. Understand the Manifests
- `deployments/blue-deployment.yaml`: stable Blue version with two replicas.
- `deployments/green-deployment.yaml`: new Green version with two replicas.
- `deployments/app-service.yaml`: stable Service endpoint initially selecting Blue Pods.

## 3. Deploy Blue and Green
From the repository root, apply the manifests:

```bash
kubectl apply -f usecase14/deployments/blue-deployment.yaml
kubectl apply -f usecase14/deployments/green-deployment.yaml
kubectl apply -f usecase14/deployments/app-service.yaml
```

Wait for both deployments to become ready:

```bash
kubectl rollout status deployment/blue-app -n usecase14-lab
kubectl rollout status deployment/green-app -n usecase14-lab
kubectl get pods -n usecase14-lab --show-labels
```

## 4. Verify Blue Traffic
The Service initially selects Pods with `version: blue`.

```bash
kubectl get endpoints blue-green-service -n usecase14-lab
kubectl run blue-green-client --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n usecase14-lab -- curl -s http://blue-green-service
```

Expected response: `BLUE-VERSION-1`.

## 5. Switch Traffic to Green
Update the Service selector to select Green Pods:

```bash
kubectl patch service blue-green-service -n usecase14-lab -p '{"spec":{"selector":{"app":"blue-green-demo","version":"green"}}}'
```

Verify the response again using the client command from Section 4.
Expected response: `GREEN-VERSION-2`.

## 6. Roll Back to Blue
Change the Service selector back to Blue:

```bash
kubectl patch service blue-green-service -n usecase14-lab -p '{"spec":{"selector":{"app":"blue-green-demo","version":"blue"}}}'
```

Verify that the response returns to `BLUE-VERSION-1`.

## 7. Troubleshooting
- Check Pods with `kubectl get pods -n usecase14-lab`.
- Inspect a failing Pod using `kubectl describe pod POD_NAME -n usecase14-lab`.
- Check the Service selector with `kubectl get service blue-green-service -n usecase14-lab -o yaml`.
- Check Service endpoints with `kubectl get endpoints blue-green-service -n usecase14-lab`.

## 8. Safety Notes
- All resources for this lab belong to `usecase14-lab`.
- Switching the Service selector changes traffic routing; it does not delete either Deployment.
- This lab demonstrates blue-green routing, not weighted canary traffic.
