#!/bin/bash
set -uo pipefail

PASS=0
FAIL=0

echo "========================================"
echo "Use Case 13 - Kyverno Policy Tests"
echo "========================================"

echo ""
echo "Test 1: latest tag must be rejected"
if OUTPUT=$(kubectl create --dry-run=server -f usecase13/tests/non-compliant-pod.yaml -o yaml 2>&1); then
  echo "$OUTPUT"
  echo "FAIL: Pod using latest was unexpectedly accepted."
  FAIL=$((FAIL + 1))
else
  echo "$OUTPUT"
  if [[ "$OUTPUT" == *"disallow-latest-tag"* ]]; then
    echo "PASS: Policy rejected the latest tag."
    PASS=$((PASS + 1))
  else
    echo "FAIL: Request failed for a reason other than the expected policy denial."
    FAIL=$((FAIL + 1))
  fi
fi

echo ""
echo "Test 2: explicit version tag must be accepted"
if OUTPUT=$(kubectl create --dry-run=server -f usecase13/tests/compliant-pod.yaml -o yaml 2>&1); then
  echo "$OUTPUT"
  echo "PASS: Explicit version tag was accepted."
  PASS=$((PASS + 1))
else
  echo "$OUTPUT"
  echo "FAIL: Explicit version tag was unexpectedly rejected."
  FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS passed; $FAIL failed."
if [[ "$FAIL" -gt 0 ]]; then
  exit 1
fi
