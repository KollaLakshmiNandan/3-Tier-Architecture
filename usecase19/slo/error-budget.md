# Error Budget

## Objective
Define the acceptable failure allowance for the Claims Management API based on its 99% availability SLO.

## Configuration
- SLO target: 99%
- Error budget: 1%
- Measurement window: 7 days

## Calculation

Error Budget = 100% - SLO Target

Error Budget = 100% - 99% = 1%

## Error Budget Monitoring
Prometheus calculates the error budget using failed and total HTTP requests over the 7-day window.

Grafana displays the remaining error budget as a percentage.

## Interpretation
- 100% remaining: No error budget consumed.
- 50% remaining: Half of the error budget consumed.
- 0% remaining: Entire error budget consumed.

## Validation
The error budget calculation was configured in Grafana using Prometheus metrics.

## Note
A complete seven-day error budget assessment requires seven days of collected metrics. Current dashboard values reflect available data.
