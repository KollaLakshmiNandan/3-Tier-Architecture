
#!/bin/bash

set -euo pipefail

NAMESPACE="usecase16-lab"
DEPLOYMENT="claims-backend"
DRIFT_REPLICAS=3

echo "======================================"
echo " USE CASE 16 - CONFIGURATION DRIFT"
echo "======================================"

echo "Current backend configuration:"
kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"

echo ""
echo "Simulating configuration drift..."
echo "Changing backend replicas from 2 to 3"

kubectl scale deployment "$DEPLOYMENT" \
  --replicas="$DRIFT_REPLICAS" \
  -n "$NAMESPACE"

echo ""
echo "Drift simulation completed!"

kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE"

echo ""
echo "Argo CD should detect this configuration difference."

