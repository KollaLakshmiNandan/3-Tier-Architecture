# UC19 – System Architecture

## Overview
This use case implements SLO monitoring and alerting for a Claims Management application.

## Components

1. Frontend
   - Provides the Claims Management user interface.

2. Backend
   - Flask REST API.
   - Exposes application metrics through `/metrics`.

3. PostgreSQL
   - Stores application data.

4. Prometheus
   - Collects backend metrics every 5 seconds.
   - Evaluates SLO alert rules.

5. Grafana
   - Visualizes API availability, request failures, latency, and error budget.

6. Alertmanager
   - Receives and manages alerts from Prometheus.

## Monitoring Flow

1. Users interact with the Claims Management application.
2. Backend processes API requests.
3. Backend exposes metrics through `/metrics`.
4. Prometheus scrapes and stores metrics.
5. Grafana queries Prometheus and displays dashboards.
6. Prometheus evaluates the 99% availability SLO.
7. Alerts are sent to Alertmanager when the condition is met.

## Deployment
The application and monitoring services run using Docker Compose.

## Service Endpoints

| Component | Endpoint |
|---|---|
| Backend API | http://localhost:5001 |
| Prometheus | http://localhost:9090 |
| Grafana | http://localhost:3001 |
| Alertmanager | http://localhost:9093 |

## Conclusion
The architecture provides application monitoring, SLO measurement, dashboard visualization, and alert management through integrated observability components.
