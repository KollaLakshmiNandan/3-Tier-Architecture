# UC19 – Implementation Guide

## 1. Application Deployment
- Built the Claims Management backend using Flask.
- Configured PostgreSQL as the application database.
- Created the frontend using React.
- Containerized application components using Docker.

## 2. Prometheus Integration
- Added Prometheus client instrumentation to the Flask backend.
- Exposed metrics through `/metrics`.
- Configured Prometheus to scrape backend metrics every 5 seconds.
- Configured SLO alert rules.

## 3. Grafana Dashboard
Created the UC19 SLO Monitoring Dashboard with:
- API availability
- Successful API requests
- Failed API requests
- P95 API response latency
- 99% SLO target
- Remaining error budget
- Actual 7-day SLO compliance

## 4. Alertmanager Integration
- Configured Prometheus to communicate with Alertmanager.
- Created an Alertmanager receiver named `uc19-console`.
- Configured an availability alert for the 99% SLO.

## 5. Alert Validation
- Generated API failures to trigger the alert.
- Verified the alert in Prometheus.
- Verified alert delivery to Alertmanager.
- Generated 2,000 successful health requests.
- Confirmed API availability recovered to 99.8177%.
- Confirmed no active alerts remained.

## 6. Deployment Endpoints

| Service | URL |
|---|---|
| Claims Backend | http://localhost:5001 |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 |
| Alertmanager | http://localhost:9093 |

## 7. Conclusion
The application, metrics collection, dashboard, and alerting integration were implemented and tested using Docker Compose.
