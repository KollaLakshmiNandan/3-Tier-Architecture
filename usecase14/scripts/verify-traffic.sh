#!/bin/bash
set -euo pipefail

NAMESPACE="usecase14-lab"
SERVICE="blue-green-service"

VERSION=$(kubectl get service "$SERVICE" -n "$NAMESPACE" -o jsonpath='{.spec.selector.version}')
echo "Service currently selects version: $VERSION"

if [[ "$VERSION" != "blue" && "$VERSION" != "green" ]]; then
  echo "ERROR: Unexpected Service version selector: $VERSION"
  exit 1
fi

echo "Checking ready Service endpoints..."
kubectl get endpoints "$SERVICE" -n "$NAMESPACE"

echo "Sending HTTP request through the Service..."
kubectl run blue-green-client --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n "$NAMESPACE" -- curl --fail --silent --show-error --max-time 10 "http://$SERVICE"
echo
echo "Traffic verification completed."
