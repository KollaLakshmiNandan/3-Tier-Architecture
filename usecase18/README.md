# Use Case 18: Troubleshoot Logging Pipeline Failure

## 1. Overview

This use case demonstrates how to implement, monitor, troubleshoot, and recover a centralized logging pipeline for a Claims Management application running on Kubernetes.

The objective is to identify where application logs stop flowing, investigate the root cause, restore log delivery, and verify that logs are searchable again.

## 2. Objectives

- Generate structured application logs.
- Collect Kubernetes container logs.
- Forward logs to a centralized destination.
- Search and investigate logs.
- Simulate a logging pipeline failure.
- Identify the root cause of log delivery failure.
- Restore the logging pipeline.
- Validate successful log delivery after recovery.

## 3. Technology Stack

| Technology | Responsibility |
|---|---|
| Flask | Application and structured logging |
| Gunicorn | Application server and access logging |
| PostgreSQL | Application database |
| Kubernetes | Application and logging workload orchestration |
| Fluent Bit | Container log collection and forwarding |
| Elasticsearch | Log indexing and storage |
| Kibana | Log searching and visualization |
| Docker | Application containerization |

## 4. Architecture

Claims Management Application  
↓  
Kubernetes Container Logs (stdout/stderr)  
↓  
Fluent Bit DaemonSet  
↓  
Elasticsearch  
↓  
Kibana Discover

### Component responsibilities

**Claims Backend**
- Generates structured JSON logs.
- Records request IDs, HTTP methods, paths, status codes, and request durations.
- Writes logs to stdout.

**Fluent Bit**
- Collects container logs from Kubernetes nodes.
- Enriches logs with Kubernetes metadata.
- Forwards logs to Elasticsearch.

**Elasticsearch**
- Stores and indexes collected logs.
- Supports searching and querying log records.

**Kibana**
- Provides a user interface for log investigation.
- Uses the `Claims Management Logs` data view.
- Supports filtering by container, namespace, message, and request ID.

## 5. Kubernetes Namespace

`usecase18-lab`

## 6. Implementation

### Step 1: Application logging

Configured structured JSON logging in the Claims Backend.

Important log fields:
- timestamp
- level
- service
- message
- request_id
- method
- path
- status_code
- duration_ms

### Step 2: Application deployment

Deployed the Claims Backend and PostgreSQL into the `usecase18-lab` namespace.

### Step 3: Elasticsearch deployment

Deployed Elasticsearch as the centralized log destination.

### Step 4: Fluent Bit configuration

Configured Fluent Bit to:
- Tail Kubernetes container log files.
- Collect logs from the `usecase18-lab` namespace.
- Enrich logs with Kubernetes metadata.
- Forward logs to Elasticsearch.
- Retry failed output operations.

### Step 5: Kibana configuration

Deployed Kibana and created the following data view:

- Name: `Claims Management Logs`
- Index pattern: `claims-logs-*`
- Timestamp field: `@timestamp`

### Step 6: Normal pipeline validation

Generated a health request against:

`GET /api/health`

Verified that the structured backend log was indexed and searchable in Kibana.

## 7. Failure Simulation

### Scenario: Incorrect Elasticsearch destination hostname

Temporarily changed the Fluent Bit output configuration from:

`Host elasticsearch`

to:

`Host elasticsearch-broken`

Applied the modified ConfigMap and restarted the Fluent Bit DaemonSet.

### Observed error

`getaddrinfo(host='elasticsearch-broken', err=4): Domain name not found`

Additional output:

`failed to flush chunk ... retry in 7 seconds`

### Root cause

Fluent Bit was configured with an invalid Elasticsearch hostname. DNS resolution failed, preventing the collector from delivering logs to Elasticsearch.

### Troubleshooting findings

- Fluent Bit started successfully.
- Kubernetes API connectivity remained healthy.
- Container log files were detected.
- Elasticsearch destination hostname resolution failed.
- Fluent Bit retried failed output chunks.

The issue was isolated to the log forwarding destination configuration.

## 8. Recovery Procedure

Restored the original Elasticsearch hostname:

`Host elasticsearch`

Applied the restored ConfigMap and restarted the Fluent Bit DaemonSet.

Validated the rollout successfully.

Generated a fresh backend health request.

### Recovery validation

Request ID:

`e7d0a7c3-13ab-461c-a376-d55b4b3f7800`

Backend response:

`HTTP 200 OK`

Verified the application log through Kubernetes:

- Service: claims-backend
- Message: HTTP request completed
- Method: GET
- Path: /api/health
- Status code: 200
- Duration: 3.2 ms

Verified the same request ID in Kibana Discover.

One matching backend document was returned.

## 9. Troubleshooting Commands

Check workloads:

`kubectl get pods,svc -n usecase18-lab`

Check backend logs:

`kubectl logs deployment/claims-backend -n usecase18-lab`

Check Fluent Bit logs:

`kubectl logs -n usecase18-lab -l app=fluent-bit --tail=50`

Check Fluent Bit DaemonSet:

`kubectl get daemonset fluent-bit -n usecase18-lab`

Check Elasticsearch indices:

`curl -s http://localhost:9200/_cat/indices?v`

Restart Fluent Bit:

`kubectl rollout restart daemonset/fluent-bit -n usecase18-lab`

Verify rollout:

`kubectl rollout status daemonset/fluent-bit -n usecase18-lab`

## 10. Final Validation Criteria

- Application generates structured logs.
- Kubernetes exposes application logs through container stdout.
- Fluent Bit collects application logs.
- Elasticsearch indexes application logs.
- Kibana can search the indexed records.
- A controlled forwarding failure can be reproduced.
- The root cause can be identified from collector logs.
- Restoring the destination configuration recovers log delivery.
- A fresh request can be found in Kibana after recovery.

## 11. Limitations and Scope

This is a local Kubernetes lab implementation.

- Elasticsearch security is disabled for the lab environment.
- PostgreSQL uses lab-oriented storage configuration.
- Fluent Bit uses memory-based buffering in the current configuration.
- Log delivery recovery is demonstrated, but durable buffering across collector restarts is not guaranteed.
- Logstash, Loki, and Splunk are not included because Elasticsearch with Fluent Bit and Kibana satisfies this implementation's selected architecture.

## 12. Conclusion

This use case demonstrates the implementation and troubleshooting of a centralized logging pipeline for a Kubernetes-based application.

A controlled Elasticsearch destination failure was introduced, the DNS resolution error was identified, and the original configuration was restored.

The recovery was validated by generating a new application request and locating its corresponding log record in Kibana.
