# Use Case 18 – Logging Pipeline Validation Report

## 1. Executive Summary

This report validates the centralized logging pipeline implemented for the Claims Management application.

The validation covers application log generation, Kubernetes log collection, Fluent Bit forwarding, Elasticsearch indexing, Kibana searching, failure simulation, root cause identification, and recovery.

## 2. Environment

| Parameter | Value |
|---|---|
| Git branch | feature/usecase18 |
| Kubernetes context | docker-desktop |
| Namespace | usecase18-lab |
| Application | Claims Management |
| Log collector | Fluent Bit 3.2.10 |
| Log destination | Elasticsearch 8.17.0 |
| Visualization | Kibana 8.17.0 |

## 3. Requirement Validation Matrix

| Step | Original requirement | Validation result | Status |
|---|---|---|---|
| 1 | Generate a known application log with service and request ID | Structured Flask JSON log generated | PASS |
| 2 | Confirm Kubernetes logs contain the message | Verified using kubectl logs | PASS |
| 3 | Search destination system for the same message | Backend log found in Elasticsearch and Kibana | PASS |
| 4 | Break one safe part of the pipeline | Incorrect Elasticsearch hostname introduced | PASS |
| 5 | Identify where the log stopped | Fluent Bit DNS resolution failure identified | PASS |
| 6 | Fix the pipeline and rerun the search | Original hostname restored and fresh log found in Kibana | PASS |
| 7 | Save the query proving logs are searchable again | Recovery query and matching Kibana document captured | PASS |

## 4. Normal Pipeline Test

### Test objective

Confirm that a known application log can travel through the logging pipeline and be searched in Kibana.

### Test request

Endpoint:

`GET /api/health`

Response:

`HTTP 200 OK`

Request ID:

`e7d0a7c3-13ab-461c-a376-d55b4b3f7800`

### Expected application log

- Service: claims-backend
- Message: HTTP request completed
- Method: GET
- Path: /api/health
- Status code: 200
- Duration: 3.2 ms

### Result

The structured application log was verified using Kubernetes logs and subsequently found in Kibana Discover.

**Result: PASS**

## 5. Failure Simulation Test

### Test objective

Demonstrate how an incorrect collector destination configuration affects log forwarding.

### Change introduced

Original destination:

`elasticsearch`

Temporary destination:

`elasticsearch-broken`

### Observed error

`getaddrinfo(host='elasticsearch-broken', err=4): Domain name not found`

Additional retry message:

`failed to flush chunk`

### Result

Fluent Bit could collect container logs, but it could not resolve the configured Elasticsearch destination.

**Result: PASS**

## 6. Recovery Test

### Test objective

Restore the destination configuration and confirm that new application logs become searchable again.

### Recovery action

Restored the original destination hostname:

`elasticsearch`

Applied the ConfigMap and restarted the Fluent Bit DaemonSet.

### Rollout result

`daemon set "fluent-bit" successfully rolled out`

### Fresh application request

Request ID:

`e7d0a7c3-13ab-461c-a376-d55b4b3f7800`

HTTP response:

`200 OK`

### Final Kibana search

Query:

```text
kubernetes.container_name : "backend" and message : "e7d0a7c3-13ab-461c-a376-d55b4b3f7800"
```

Matching documents:

`1`

### Result

The same request ID was found in Kibana after recovery.

**Result: PASS**

## 7. Evidence Register

| Evidence ID | Required proof | Evidence file |
|---|---|---|
| EV-01 | Kubernetes workloads | 01-kubernetes-workloads.png |
| EV-02 | Backend structured logs | 02-backend-json-logs.png |
| EV-03 | Fluent Bit collector | 03-fluent-bit-collector.png |
| EV-04 | Elasticsearch index | 04-elasticsearch-index.png |
| EV-05 | Kibana Data View | 05-kibana-data-view.png |
| EV-06 | Backend logs in Kibana | 06-kibana-backend-logs.png |
| EV-07 | DNS failure during simulation | 07-failure-dns-error.png |
| EV-08 | Fluent Bit recovery | 08-fluent-bit-recovery.png |
| EV-09 | Backend health after recovery | 09-backend-health-after-recovery.png |
| EV-10 | Recovered log in Kibana | 10-kibana-log-after-recovery.png |

Evidence files must be added to the repository before final submission.

## 8. Acceptance Criteria

- [x] Known application log generated.
- [x] Kubernetes log verified.
- [x] Backend log searchable in Elasticsearch.
- [x] Backend log visible in Kibana.
- [x] Controlled pipeline failure introduced.
- [x] Root cause identified.
- [x] Original configuration restored.
- [x] Fresh log verified after recovery.
- [ ] All evidence screenshots saved in the repository.

## 9. Final Conclusion

The centralized logging pipeline was implemented and validated.

A controlled Elasticsearch destination failure was reproduced and investigated. The root cause was identified as an invalid DNS hostname in the Fluent Bit output configuration.

After restoring the original configuration, a new application request was generated and its corresponding log was successfully found in Kibana.

The implementation demonstrates the required logging pipeline troubleshooting and recovery workflow.