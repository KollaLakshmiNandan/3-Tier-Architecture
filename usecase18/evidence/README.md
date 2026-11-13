# Use Case 18 – Evidence Register

## Purpose

This directory contains execution evidence collected during the implementation, failure simulation, troubleshooting, and recovery of the centralized logging pipeline.

## Evidence Inventory

| ID | Evidence | Description |
|---|---|---|
| EV-01 | 01-kubernetes-workloads.png | Kubernetes pods and services in usecase18-lab |
| EV-02 | 02-backend-json-logs.png | Structured Claims Backend application logs |
| EV-03 | 03-fluent-bit-collector.png | Fluent Bit startup and log collection |
| EV-04 | 04-elasticsearch-index.png | Elasticsearch index and indexed documents |
| EV-05 | 05-kibana-data-view.png | Claims Management Logs Data View |
| EV-06 | 06-kibana-backend-logs.png | Backend application logs in Kibana |
| EV-07 | 07-failure-dns-error.png | Invalid Elasticsearch hostname and DNS failure |
| EV-08 | 08-fluent-bit-recovery.png | Fluent Bit restored and successfully rolled out |
| EV-09 | 09-backend-health-after-recovery.png | Fresh backend health request and HTTP 200 |
| EV-10 | 10-kibana-log-after-recovery.png | Fresh request ID searchable in Kibana |

## Evidence Collection Guidelines

- Capture the actual terminal or application screen.
- Keep relevant timestamps and output visible.
- Do not fabricate or edit command results.
- Use the listed filenames for consistent referencing.
- Keep screenshots relevant to the specific validation step.

## Evidence Status

Evidence filenames are reserved for the ten validation checkpoints. Add the corresponding actual screenshots before marking the evidence package complete.