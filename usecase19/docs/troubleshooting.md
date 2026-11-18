# UC19 – Troubleshooting Guide

## 1. Backend Not Accessible
- Check backend container status.
- Verify port 5001.
- Check backend logs.

Command:
docker logs uc19-backend

## 2. Prometheus Target Down
- Open http://localhost:9090/targets
- Verify the claims-backend target.
- Check the backend metrics endpoint.

Command:
curl http://localhost:5001/metrics

## 3. Grafana Dashboard No Data
- Verify Prometheus data source.
- Check Prometheus target status.
- Verify dashboard PromQL queries.

Grafana URL:
http://localhost:3001

## 4. Alert Not Triggering
- Open Prometheus alerts page.
- Verify the SLO alert rule.
- Check API availability query.
- Confirm the alert condition remains below 99% for 2 minutes.

Prometheus URL:
http://localhost:9090/alerts

## 5. Alertmanager Not Receiving Alerts
- Verify Alertmanager is running.
- Check Prometheus alertmanager configuration.
- Check Alertmanager UI.

Alertmanager URL:
http://localhost:9093

## 6. Port Conflict
Check whether another service is using the required host port before starting containers.

## 7. Validation Commands

docker compose -f usecase19/docker-compose.yml ps

curl http://localhost:5001/api/health

curl http://localhost:9090/-/healthy

curl http://localhost:9093/-/ready
