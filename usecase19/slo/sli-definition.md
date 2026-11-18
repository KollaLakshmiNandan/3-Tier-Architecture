# Service Level Indicator (SLI)

## Objective
Define the measurable indicators used to monitor Claims Management API reliability.

## Primary SLI – API Availability

Measures the percentage of successful HTTP requests.

Formula:

Successful Requests / Total Requests × 100

## Supporting SLIs

1. Request Success Rate
   - Tracks successful API requests.
   - Metric: claims_http_requests_total

2. Request Failure Rate
   - Tracks HTTP 4xx and 5xx responses.
   - Metric: claims_http_request_errors_total

3. API Response Latency
   - Measures API request duration.
   - Metric: claims_http_request_duration_seconds

## Monitoring
Prometheus collects these metrics from the backend `/metrics` endpoint.

Grafana visualizes availability, successful requests, failed requests, and P95 response latency.

## Validation
The monitoring system successfully collected backend metrics and displayed them in the Grafana dashboard.
