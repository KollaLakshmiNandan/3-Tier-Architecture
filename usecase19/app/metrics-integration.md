# UC19 – Application Metrics Integration

## Objective
Integrate Prometheus metrics into the Claims Management Flask backend.

## Metrics Exposed

| Metric | Purpose |
|---|---|
| claims_http_requests_total | Counts HTTP requests |
| claims_http_request_errors_total | Counts failed requests |
| claims_http_request_duration_seconds | Measures request duration |

## Metrics Endpoint

```text
http://localhost:5001/metrics
