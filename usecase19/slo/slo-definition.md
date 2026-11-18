# Service Level Objective (SLO)

## Objective
Define the availability target for the Claims Management API.

## SLO Target
- Service: Claims Management API
- Availability target: 99%
- Measurement window: 7 days
- Allowed failure rate: 1%

## Measurement
Availability is calculated as:

Successful HTTP requests / Total HTTP requests × 100

HTTP 4xx and 5xx responses are counted as failed requests in this lab.

## Alerting
An alert is triggered when API availability falls below 99% for 2 minutes.

## Validation
The alert was triggered successfully when availability dropped below the target. After generating successful recovery traffic, availability reached 99.8177%, and no active alerts remained.

## Note
The seven-day SLO is a lab configuration. A complete seven-day compliance assessment requires seven days of collected metrics.
