# Use Case 13: Kubernetes Policy as Code with Kyverno

## 1. Overview

This use case demonstrates Kubernetes Policy as Code using Kyverno.
A policy is defined in YAML and enforced automatically when Kubernetes
receives a Pod creation request.

## 2. Problem Statement

Using the `latest` container image tag can make deployments less
predictable because the tag can refer to different image versions over time.

## 3. Objective

- Install Kyverno in a Kubernetes cluster using Helm.
- Define a policy that rejects Pods using the `latest` image tag.
- Allow Pods that specify an explicit image version.
- Validate the policy using Kubernetes server-side dry runs.
- Maintain the policy and supporting evidence in Git.

## 4. Architecture

Developer submits a Pod manifest
        |
        v
Kubernetes API Server
        |
        v
Kyverno Admission Controller
        |
        v
Evaluate disallow-latest-tag policy
        |
        +---- nginx:latest ----> Rejected
        |
        +---- nginx:1.28 ------> Accepted

## 5. Technology Stack

- Kubernetes
- Docker Desktop Kubernetes
- Kyverno
- Helm
- kubectl
- YAML
- Git and GitLab

## 6. Repository Structure

- `policies/` - Kyverno policy definitions.
- `tests/` - Compliant and non-compliant Pod test manifests.
- `scripts/` - Installation, policy deployment, and test scripts.
- `docs/` - Architecture and implementation documentation.
- `evidence/` - Actual command outputs collected during testing.

## 7. Policy Implemented

File: `policies/disallow-latest-tag.yaml`

The policy rejects Pods whose container image uses the `latest` tag.
It uses the Kyverno `ClusterPolicy` API with enforcement enabled.

Note: This policy uses a legacy Kyverno API that is deprecated in the
installed Kyverno version. Migration to the newer policy API is a
possible future improvement.

## 8. Validation Results

| Test | Expected result | Observed result |
|---|---|---|
| Pod using `nginx:latest` | Rejected | Rejected by Kyverno |
| Pod using `nginx:1.28` | Accepted | Server-side dry run returned Pod YAML |
| Kyverno controller health | All controllers ready | All four Pods reached 1/1 Ready |
| Policy readiness | Ready | Policy reported Ready |

Both Pod tests used `--dry-run=server`; they validated admission
without creating persistent Pods.

## 9. Prerequisites

- Docker Desktop Kubernetes enabled.
- kubectl configured for the intended cluster.
- Helm installed.
- Network access to the Kyverno image registry.
- Permission to install Kyverno and create cluster-scoped policies.

## 10. Implementation Guide

See `docs/implementation-guide.md` for the setup and deployment steps.

## 11. Test Documentation

See `docs/test-results.md` for the test cases and observed results.

## 12. Evidence

The `evidence/` directory contains command outputs captured from the
environment. Evidence should be collected from actual command execution,
not manually fabricated.

## 13. Limitations

- This use case implements one image-tag policy only.
- An explicit version tag does not guarantee image immutability; image
  digests provide stronger version pinning.
- The tests use server-side dry runs and do not deploy a running test app.
- This lab does not implement image signature verification or vulnerability scanning.

## 14. Cleanup

Cleanup instructions will be documented after the test and policy
resources have been reviewed. Do not uninstall Kyverno if other use cases
or workloads depend on it.
