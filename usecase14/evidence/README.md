# Use Case 14: Evidence

This directory stores actual command outputs collected while testing the blue-green deployment.

## Evidence Files
- `01-deployment-status.txt`: Blue and Green deployment readiness.
- `02-blue-traffic.txt`: HTTP response while the Service selects Blue.
- `03-green-traffic.txt`: HTTP response after switching the Service to Green.
- `04-rollback-verification.txt`: HTTP response after switching back to Blue.

## Collection Rules
- Capture outputs from the actual Kubernetes cluster.
- Do not create or edit output files to make a test appear successful.
- A test passes only when the observed response matches the expected version.

## Expected Responses
- Blue: `BLUE-VERSION-1`
- Green: `GREEN-VERSION-2`
