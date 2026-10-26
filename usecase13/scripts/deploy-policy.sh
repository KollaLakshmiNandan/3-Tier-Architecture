#!/bin/bash
set -euo pipefail

POLICY_FILE="usecase13/policies/disallow-latest-tag.yaml"

if [[ ! -f "$POLICY_FILE" ]]; then
  echo "ERROR: Policy file not found: $POLICY_FILE"
  exit 1
fi

echo "Checking Kyverno readiness..."
kubectl get pods -n kyverno

echo "Applying the image-tag policy..."
kubectl apply -f "$POLICY_FILE"

echo "Checking policy status..."
kubectl get clusterpolicy disallow-latest-tag -o wide

echo "Policy deployment check completed."
