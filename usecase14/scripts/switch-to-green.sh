#!/bin/bash
set -euo pipefail

NAMESPACE="usecase14-lab"
SERVICE="blue-green-service"

echo "Checking Green deployment readiness..."
kubectl rollout status deployment/green-app -n "$NAMESPACE" --timeout=180s

READY=$(kubectl get deployment green-app -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
if [[ "$READY" != "2" ]]; then
  echo "ERROR: Green deployment does not have 2 ready replicas. Traffic was not switched."
  exit 1
fi

echo "Switching Service traffic to Green..."
kubectl patch service "$SERVICE" -n "$NAMESPACE" --type=merge -p '{"spec":{"selector":{"app":"blue-green-demo","version":"green"}}}'

echo "Current Service selector:"
kubectl get service "$SERVICE" -n "$NAMESPACE" -o jsonpath='{.spec.selector}'
echo
echo "Traffic switch to Green completed."
