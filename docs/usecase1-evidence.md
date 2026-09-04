# Use Case 1 - Build, Test, Scan, and Publish

## Application
Claims Management 3-Tier Application

## Git
Branch: feature/usecase1-pipeline

Commit:
af1c004fda7916cfe141b2c5fc0963566c3b5056

## GitLab Pipeline
Pipeline: #2819156539

Status: Passed

Stages:
- Unit Test
- SonarQube
- Docker Build
- Trivy Scan
- Publish Image

## SonarQube
Quality Gate: Passed

## Trivy
Image vulnerability scan completed successfully.

The pipeline continues even when HIGH/CRITICAL findings are reported because the scan is configured with --exit-code 0.

## Container Image

Registry:
GitLab Container Registry

Image tag:
af1c004fda7916cfe141b2c5fc0963566c3b5056

Manifest digest:
sha256:595b83836835ae5642ce0734507a685a241fa3165fa2705afc94c1a39bca4d6

Platform:
linux/arm64

## Traceability

Git Commit
    ↓
GitLab Pipeline
    ↓
Unit Test
    ↓
SonarQube
    ↓
Docker Build
    ↓
Trivy Scan
    ↓
Published Container Image
    ↓
Immutable Image Digest
