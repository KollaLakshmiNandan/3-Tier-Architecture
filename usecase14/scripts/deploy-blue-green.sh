#!/bin/bash
set -euo pipefail

NAMESPACE="usecase14-lab"
BASE="usecase14/deployments"

echo "Deploying Blue and Green versions..."
kubectl apply -f "$BASE/blue-deployment.yaml"
kubectl apply -f "$BASE/green-deployment.yaml"
kubectl apply -f "$BASE/app-service.yaml"

echo "Waiting for Blue deployment..."
kubectl rollout status deployment/blue-app -n "$NAMESPACE" --timeout=180s

echo "Waiting for Green deployment..."
kubectl rollout status deployment/green-app -n "$NAMESPACE" --timeout=180s

echo "Deployment status:"
kubectl get deployments,pods,service -n "$NAMESPACE"
echo "Deployment setup completed."
