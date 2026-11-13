# Use Case 18 – Logging Pipeline Implementation Guide

## 1. Objective

Implement a centralized logging pipeline for the Claims Management application using Kubernetes, Fluent Bit, Elasticsearch, and Kibana.

The implementation covers application log generation, collection, forwarding, indexing, visualization, and validation.

## 2. Environment

| Item | Configuration |
|---|---|
| Repository | devopshub |
| Git branch | feature/usecase18 |
| Kubernetes context | docker-desktop |
| Namespace | usecase18-lab |
| Backend | Flask + Gunicorn |
| Database | PostgreSQL |
| Log collector | Fluent Bit 3.2.10 |
| Log destination | Elasticsearch 8.17.0 |
| Log interface | Kibana 8.17.0 |

## 3. Repository Structure

```text
usecase18/
├── README.md
├── collector/
│   ├── configmap.yaml
│   ├── daemonset.yaml
│   ├── fluent-bit.conf
│   └── rbac.yaml
├── database/
│   └── init.sql
├── kubernetes/
│   ├── backend.yaml
│   ├── elasticsearch.yaml
│   ├── kibana.yaml
│   └── postgres.yaml
├── docs/
└── evidence/
```

## 4. Application Logging Implementation

The existing Claims Management Flask backend was configured to produce structured JSON logs.

The log formatter records:

- Timestamp
- Level
- Service
- Message
- Request ID
- HTTP method
- Request path
- HTTP status code
- Request duration

Gunicorn runs the application and sends access and error logs to stdout/stderr.

## 5. Kubernetes Deployment

All Use Case 18 resources are deployed into:

`usecase18-lab`

Verify the namespace:

```bash
kubectl get namespace usecase18-lab
```

Inspect workloads:

```bash
kubectl get pods,svc -n usecase18-lab
```

## 6. PostgreSQL Deployment

Manifest:

`usecase18/kubernetes/postgres.yaml`

PostgreSQL provides the application database.

Initialization SQL:

`usecase18/database/init.sql`

## 7. Elasticsearch Deployment

Manifest:

`usecase18/kubernetes/elasticsearch.yaml`

Elasticsearch provides centralized log storage and indexing.

The Fluent Bit output uses:

- Host: elasticsearch
- Port: 9200
- Index prefix: claims-logs

Verify Elasticsearch connectivity using a port-forward:

```bash
kubectl port-forward svc/elasticsearch 9200:9200 -n usecase18-lab
```

In another terminal:

```bash
curl -s http://localhost:9200
```

## 8. Fluent Bit Deployment

Configuration files:

- `usecase18/collector/fluent-bit.conf`
- `usecase18/collector/configmap.yaml`
- `usecase18/collector/rbac.yaml`
- `usecase18/collector/daemonset.yaml`

Fluent Bit is deployed as a DaemonSet to collect container logs.

Apply the RBAC configuration:

```bash
kubectl apply -f usecase18/collector/rbac.yaml
```

Apply the ConfigMap:

```bash
kubectl apply -f usecase18/collector/configmap.yaml
```

Deploy the collector:

```bash
kubectl apply -f usecase18/collector/daemonset.yaml
```

Verify the DaemonSet:

```bash
kubectl get daemonset fluent-bit -n usecase18-lab
```

Inspect collector logs:

```bash
kubectl logs -n usecase18-lab -l app=fluent-bit --tail=50
```

## 9. Kibana Deployment

Manifest:

`usecase18/kubernetes/kibana.yaml`

Start port forwarding:

```bash
kubectl port-forward svc/kibana 5601:5601 -n usecase18-lab
```

Open:

`http://localhost:5601`

Create a data view:

| Setting | Value |
|---|---|
| Name | Claims Management Logs |
| Index pattern | claims-logs-* |
| Timestamp field | @timestamp |

Use Discover to search the collected logs.

## 10. Normal Logging Validation

Start backend port forwarding:

```bash
kubectl port-forward svc/claims-backend 5000:5000 -n usecase18-lab
```

Generate a health request:

```bash
curl -i http://localhost:5000/api/health
```

Verify backend logs:

```bash
kubectl logs deployment/claims-backend -n usecase18-lab --since=5m
```

Filter using the request ID:

```bash
kubectl logs deployment/claims-backend -n usecase18-lab --since=5m | grep <REQUEST_ID>
```

## 11. Elasticsearch Log Search

With Elasticsearch port-forward active:

```bash
curl -s "http://localhost:9200/claims-logs-*/_search?pretty&size=5" \
-H "Content-Type: application/json" \
-d '{
  "query": {
    "match_phrase": {
      "message": "HTTP request completed"
    }
  }
}'
```

## 12. Final Validation

The implementation was validated by:

1. Confirming all required workloads were running.
2. Generating application health requests.
3. Verifying structured logs in Kubernetes.
4. Confirming application logs were indexed in Elasticsearch.
5. Searching backend logs in Kibana.
6. Simulating an invalid Elasticsearch destination.
7. Identifying the DNS resolution failure.
8. Restoring the correct destination.
9. Generating a new request and confirming its log in Kibana.

## 13. Result

The centralized logging pipeline was implemented and tested successfully.

A controlled output failure was reproduced, diagnosed, and recovered by restoring the Elasticsearch destination hostname.