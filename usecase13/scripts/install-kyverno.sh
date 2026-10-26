#!/bin/bash
set -euo pipefail

echo "Checking Kubernetes context..."
kubectl config current-context

echo "Checking Helm installation..."
helm version

echo "Adding the official Kyverno Helm repository..."
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

if helm status kyverno -n kyverno >/dev/null 2>&1; then
  echo "Kyverno is already installed in namespace kyverno."
else
  echo "Installing Kyverno..."
  helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
fi

echo "Waiting for Kyverno deployments to become ready..."
kubectl rollout status deployment -n kyverno --timeout=180s

echo "Kyverno installation check completed."
