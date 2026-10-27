#!/bin/bash
set -euo pipefail

NAMESPACE="usecase14-lab"
SERVICE="blue-green-service"

echo "Checking Blue deployment readiness..."
kubectl rollout status deployment/blue-app -n "$NAMESPACE" --timeout=180s

READY=$(kubectl get deployment blue-app -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
if [[ "$READY" != "2" ]]; then
  echo "ERROR: Blue deployment does not have 2 ready replicas. Rollback was not performed."
  exit 1
fi

echo "Rolling back traffic to Blue..."
kubectl patch service "$SERVICE" -n "$NAMESPACE" --type=merge -p '{"spec":{"selector":{"app":"blue-green-demo","version":"blue"}}}'

echo "Current Service selector:"
kubectl get service "$SERVICE" -n "$NAMESPACE" -o jsonpath='{.spec.selector}'
echo
echo "Rollback to Blue completed."
