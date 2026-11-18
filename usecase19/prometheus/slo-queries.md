
# UC19 – Prometheus SLO Monitoring Queries

## 1. Overview

This document contains the PromQL queries used for monitoring the Claims Management application.

Prometheus collects application metrics from the Flask backend through the `/metrics` endpoint.

**Monitoring components:**
- Prometheus – Metrics collection and querying
- Grafana – Dashboard visualization
- Alertmanager – Alert management and routing

## 2. API Availability

**Purpose:** Measures the percentage of successful API requests over the last 5 minutes.

```promql
(
  sum(rate(claims_http_requests_total{status!~"4..|5.."}[5m]))
  /
  sum(rate(claims_http_requests_total[5m]))
) * 100
```

**Interpretation:** The lab SLO target is 99% API availability.

## 3. Successful API Requests

**Purpose:** Measures successful API requests over the last 5 minutes.

```promql
sum(increase(claims_http_requests_total{status!~"4..|5.."}[5m]))
```

## 4. Failed API Requests

**Purpose:** Measures failed API requests with HTTP 4xx and 5xx responses over the last 5 minutes.

```promql
sum(increase(claims_http_requests_total{status=~"4..|5.."}[5m]))
```

## 5. API Response Latency – P95

**Purpose:** Measures the 95th percentile API response latency in milliseconds.

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(claims_http_request_duration_seconds_bucket[5m])
  )
) * 1000
```

## 6. SLO Target

**Purpose:** Displays the configured 99% availability target.

```promql
vector(99)
```

## 7. Actual 7-Day SLO Compliance

**Purpose:** Measures successful requests as a percentage of total requests over a 7-day window.

```promql
(
  sum(increase(claims_http_requests_total{status!~"4..|5.."}[7d]))
  /
  sum(increase(claims_http_requests_total[7d]))
) * 100
```

**Note:** Until seven complete days of metrics are collected, this calculation reflects only the data available within the selected window.

## 8. Error Budget Remaining

**Purpose:** Calculates the remaining error budget against the 99% SLO target.

```promql
clamp(
  (
    1 -
    (
      (
        sum(increase(claims_http_requests_total{status=~"4..|5.."}[7d]))
        /
        sum(increase(claims_http_requests_total[7d]))
      ) / 0.01
    )
  ) * 100,
  0,
  100
)
```

**Interpretation:**
- 100% – Entire error budget remains.
- 50% – Half of the error budget has been consumed.
- 0% – Error budget is exhausted.

## 9. Availability SLO Alert Expression

**Purpose:** Triggers an alert when API availability remains below 99%.

```promql
(
  sum(rate(claims_http_requests_total{status!~"4..|5.."}[5m]))
  /
  sum(rate(claims_http_requests_total[5m]))
) * 100 < 99
```

The alert rule uses a 2-minute pending duration before firing.

## 10. Metric Reference

| Metric | Description |
|---|---|
| claims_http_requests_total | Total HTTP requests |
| claims_http_request_errors_total | Failed HTTP requests |
| claims_http_request_duration_seconds | HTTP request duration histogram |

## 11. Monitoring Validation

The following validation was completed:

- Backend metrics exposed through `/metrics`.
- Prometheus successfully scraped backend metrics.
- Grafana dashboard displayed application metrics.
- API availability dropped below the 99% target.
- Prometheus generated the SLO alert.
- Alertmanager successfully received the alert.
- Recovery traffic was generated using successful health requests.
- API availability recovered to 99.8177%.
- Prometheus reported no active alerts.
- Alertmanager reported no active alerts.

## 12. Conclusion

Prometheus-based SLO monitoring was implemented for the Claims Management application. Grafana provides visibility into API availability, request outcomes, latency, SLO compliance, and error budget consumption.

The alert lifecycle was validated from alert generation through recovery, including successful delivery to Alertmanager.

