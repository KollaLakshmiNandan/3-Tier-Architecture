# Use Case 18 – Logging Pipeline Failure Analysis

## 1. Incident Overview

| Field | Details |
|---|---|
| Incident | Centralized logging delivery failure |
| Environment | Local Kubernetes |
| Namespace | usecase18-lab |
| Affected component | Fluent Bit Elasticsearch output |
| Log destination | Elasticsearch |
| Severity | Lab simulation |
| Failure type | DNS resolution failure |
| Resolution | Restore correct Elasticsearch hostname |

## 2. Incident Objective

The objective was to simulate a logging pipeline failure, identify where log delivery stopped, investigate the root cause, restore the configuration, and validate successful log delivery.

## 3. Baseline Before Failure

Before introducing the failure:

- Claims Backend was running.
- PostgreSQL was running.
- Fluent Bit was running as a DaemonSet.
- Elasticsearch was running.
- Kibana was accessible.
- Backend application logs were searchable in Kibana.

The normal logging flow was:

Application → Kubernetes Logs → Fluent Bit → Elasticsearch → Kibana

## 4. Failure Scenario

### Description

A controlled configuration failure was introduced by changing the Fluent Bit Elasticsearch output hostname.

Original configuration:

```ini
[OUTPUT]
    Name                es
    Match               kube.*
    Host                elasticsearch
    Port                9200
```

Faulty configuration:

```ini
[OUTPUT]
    Name                es
    Match               kube.*
    Host                elasticsearch-broken
    Port                9200
```

The incorrect hostname was applied through the Fluent Bit ConfigMap.

The Fluent Bit DaemonSet was restarted to load the modified configuration.

## 5. Observed Symptoms

Fluent Bit reported:

```text
getaddrinfo(host='elasticsearch-broken', err=4):
Domain name not found
```

It also reported:

```text
failed to flush chunk
retry in 7 seconds
```

### Interpretation

- Fluent Bit started successfully.
- Kubernetes API connectivity remained healthy.
- Container log files were detected.
- The Elasticsearch hostname could not be resolved.
- Log delivery failed at the output stage.
- Fluent Bit attempted to retry failed chunks.

## 6. Root Cause Analysis

### Root cause

The Elasticsearch output hostname in the Fluent Bit configuration was incorrect.

The configured hostname `elasticsearch-broken` did not resolve through Kubernetes DNS.

### Failure location

The failure occurred between:

Fluent Bit → Elasticsearch

### Why did the pipeline fail?

Fluent Bit uses the configured destination hostname to connect to Elasticsearch.

Because the destination hostname was invalid, DNS resolution failed. As a result, Fluent Bit could not forward collected log chunks to Elasticsearch.

### Components not identified as the root cause

- Claims Backend
- PostgreSQL
- Kubernetes API
- Fluent Bit input configuration

The observed errors specifically identified the output destination configuration as the problem.

## 7. Troubleshooting Process

| Step | Investigation | Finding |
|---|---|---|
| 1 | Checked Kubernetes workloads | Required pods were Running |
| 2 | Checked backend logs | Application logs were generated |
| 3 | Checked Fluent Bit startup | Collector initialized successfully |
| 4 | Checked Kubernetes API connectivity | Connectivity OK |
| 5 | Checked Fluent Bit output errors | DNS resolution failed |
| 6 | Inspected destination hostname | Incorrect hostname found |
| 7 | Restored destination hostname | Correct configuration applied |

## 8. Recovery Actions

The original Fluent Bit ConfigMap was restored.

Correct destination:

```ini
Host elasticsearch
```

The restored ConfigMap was applied:

```bash
kubectl apply -f usecase18/collector/configmap.yaml
```

Fluent Bit was restarted:

```bash
kubectl rollout restart daemonset/fluent-bit -n usecase18-lab
```

Rollout verification:

```bash
kubectl rollout status daemonset/fluent-bit -n usecase18-lab
```

Observed result:

```text
daemon set "fluent-bit" successfully rolled out
```

## 9. Post-Recovery Validation

A fresh backend health request was generated.

Endpoint:

`GET /api/health`

Response:

`HTTP 200 OK`

Request ID:

`e7d0a7c3-13ab-461c-a376-d55b4b3f7800`

The backend generated this structured log:

```json
{
  "level": "INFO",
  "service": "claims-backend",
  "message": "HTTP request completed",
  "request_id": "e7d0a7c3-13ab-461c-a376-d55b4b3f7800",
  "method": "GET",
  "path": "/api/health",
  "status_code": 200,
  "duration_ms": 3.2
}
```

The same request ID was subsequently found in Kibana Discover.

One matching backend document was returned.

## 10. Incident Resolution

| Validation | Result |
|---|---|
| Correct hostname restored | Successful |
| ConfigMap applied | Successful |
| Fluent Bit restarted | Successful |
| DaemonSet rollout | Successful |
| Backend health request | HTTP 200 |
| Kubernetes application log | Verified |
| Kibana request ID search | One matching document |

## 11. Lessons Learned

1. A running collector does not guarantee successful log delivery.
2. Input collection and output forwarding must be investigated separately.
3. DNS resolution is an important dependency in Kubernetes service communication.
4. Fluent Bit retry messages help identify output delivery failures.
5. Configuration changes should be validated and rolled back carefully.
6. Recovery must be proven by generating and searching for a fresh application log.

## 12. Conclusion

The logging pipeline failure was reproduced through an incorrect Elasticsearch hostname.

The issue was identified using Fluent Bit logs, and the original destination configuration was restored.

Post-recovery validation confirmed that a fresh Claims Backend application log was successfully searchable in Kibana.

The incident demonstrates a complete troubleshooting workflow: failure simulation, symptom identification, root cause analysis, corrective action, and recovery validation.