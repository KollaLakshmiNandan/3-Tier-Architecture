
#!/bin/bash

set -euo pipefail

NAMESPACE="usecase16-lab"

echo "======================================"
echo " USE CASE 16 - STATE VERIFICATION"
echo "======================================"

echo ""
echo "1. Kubernetes deployment status"

kubectl get deployments -n "$NAMESPACE"

echo ""
echo "2. Expected replica configuration"

EXPECTED_BACKEND=2
EXPECTED_FRONTEND=2
EXPECTED_POSTGRES=1

echo "Backend expected replicas: $EXPECTED_BACKEND"
echo "Frontend expected replicas: $EXPECTED_FRONTEND"
echo "PostgreSQL expected replicas: $EXPECTED_POSTGRES"

echo ""
echo "3. Actual replica configuration"

kubectl get deployment claims-backend \
  -n "$NAMESPACE" \
  -o jsonpath='Backend: {.spec.replicas}{"\n"}'

kubectl get deployment claims-frontend \
  -n "$NAMESPACE" \
  -o jsonpath='Frontend: {.spec.replicas}{"\n"}'

kubectl get deployment postgres \
  -n "$NAMESPACE" \
  -o jsonpath='PostgreSQL: {.spec.replicas}{"\n"}'

echo ""
echo "4. Terraform drift baseline"

kubectl get configmap usecase16-drift-baseline \
  -n "$NAMESPACE" -o yaml

echo ""
echo "Verification report completed."

