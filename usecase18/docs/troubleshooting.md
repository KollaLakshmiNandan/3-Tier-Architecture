# Use Case 18 – Logging Pipeline Troubleshooting Guide

## 1. Purpose

This guide provides a systematic approach to troubleshooting missing or delayed application logs in the Claims Management logging pipeline.

The troubleshooting process covers application log generation, Kubernetes collection, Fluent Bit processing, Elasticsearch delivery, and Kibana search.

## 2. Logging Pipeline

Claims Backend → Kubernetes Container Logs → Fluent Bit → Elasticsearch → Kibana

## 3. Troubleshooting Workflow

### Step 1: Verify application log generation

Check backend pod status:

```bash
kubectl get pods -n usecase18-lab
```

Check application logs:

```bash
kubectl logs deployment/claims-backend -n usecase18-lab --since=10m
```

Generate a test request:

```bash
curl -i http://localhost:5000/api/health
```

Expected result: HTTP 200 OK and a healthy service response.

### Step 2: Verify Kubernetes log availability

Identify the backend pod:

```bash
kubectl get pods -n usecase18-lab
```

Inspect its logs:

```bash
kubectl logs deployment/claims-backend -n usecase18-lab
```

Confirm that the application log is present in stdout.

### Step 3: Verify Fluent Bit collector

Check the DaemonSet:

```bash
kubectl get daemonset fluent-bit -n usecase18-lab
```

Check collector pods:

```bash
kubectl get pods -n usecase18-lab -l app=fluent-bit
```

Inspect collector logs:

```bash
kubectl logs -n usecase18-lab -l app=fluent-bit --tail=50
```

Look for:
- Collector initialization errors
- Input tail errors
- Kubernetes API connectivity errors
- Parser errors
- Elasticsearch DNS errors
- Output retry messages

### Step 4: Verify Fluent Bit configuration

Inspect the ConfigMap:

```bash
kubectl get configmap fluent-bit-config -n usecase18-lab -o yaml
```

Check the output destination:

```ini
[OUTPUT]
    Name es
    Match kube.*
    Host elasticsearch
    Port 9200
```

Verify that the destination hostname matches the Kubernetes Elasticsearch Service.

### Step 5: Verify Elasticsearch

Check Elasticsearch pod:

```bash
kubectl get pods -n usecase18-lab
```

Check the Service:

```bash
kubectl get svc elasticsearch -n usecase18-lab
```

Check Elasticsearch connectivity using port forwarding:

```bash
kubectl port-forward svc/elasticsearch 9200:9200 -n usecase18-lab
```

In another terminal:

```bash
curl -s http://localhost:9200
```

Inspect indices:

```bash
curl -s "http://localhost:9200/_cat/indices?v"
```

### Step 6: Verify Kibana

Start port forwarding:

```bash
kubectl port-forward svc/kibana 5601:5601 -n usecase18-lab
```

Open:

`http://localhost:5601`

Navigate to Discover and select:

`Claims Management Logs`

Index pattern:

`claims-logs-*`

Use a request ID or application message to search for the expected log.

## 4. Common Failure Scenarios

| Symptom | Possible investigation area |
|---|---|
| No application log | Backend application and stdout |
| Backend log exists but not in Elasticsearch | Fluent Bit input and output |
| Fluent Bit pod not running | DaemonSet and container startup |
| DNS resolution failure | Elasticsearch service hostname |
| Connection refused | Elasticsearch availability and service port |
| Parser errors | CRI parser and log format |
| Logs exist but not visible in Kibana | Data view, time range, and index pattern |

## 5. Failure Scenario Demonstrated

The implemented failure scenario used an incorrect Elasticsearch destination hostname.

Incorrect:

`elasticsearch-broken`

Observed error:

`getaddrinfo(host='elasticsearch-broken', err=4): Domain name not found`

Root cause: Fluent Bit could not resolve the configured Elasticsearch destination.

## 6. Recovery Commands

Restore the correct destination:

`Host elasticsearch`

Apply the ConfigMap:

```bash
kubectl apply -f usecase18/collector/configmap.yaml
```

Restart Fluent Bit:

```bash
kubectl rollout restart daemonset/fluent-bit -n usecase18-lab
```

Verify the rollout:

```bash
kubectl rollout status daemonset/fluent-bit -n usecase18-lab
```

Inspect collector startup:

```bash
kubectl logs -n usecase18-lab -l app=fluent-bit --since=3m --tail=40
```

Generate a fresh application request and verify that the corresponding request ID is searchable in Kibana.

## 7. Troubleshooting Best Practices

1. Start at the application and follow the log through each pipeline component.
2. Separate collection problems from forwarding problems.
3. Inspect actual error messages instead of restarting every component.
4. Verify Kubernetes service names and destination ports.
5. Preserve the working configuration before introducing changes.
6. Use a fresh request ID to validate recovery.
7. Record the root cause and corrective action.

## 8. Completion Criteria

Troubleshooting is complete when:

Application logs are generated.

Kubernetes exposes the logs.

Fluent Bit collects the logs.

Elasticsearch indexes the logs.

Kibana can search the records.

Any identified failure has been corrected.

A fresh log is searchable after recovery.