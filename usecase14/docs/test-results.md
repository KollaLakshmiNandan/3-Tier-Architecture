# Use Case 14 — Blue-Green Deployment Test Results

## Test Environment
- Kubernetes context: Docker Desktop
- Namespace: usecase14-lab
- Blue deployment: blue-app, 2 replicas
- Green deployment: green-app, 2 replicas
- Service: blue-green-service

## Test Results

| Test | Expected Result | Observed Result | Status |
|---|---|---|---|
| Initial deployment | Blue and Green deployments ready | Both deployments reached 2/2 ready replicas | PASS |
| Blue traffic | Service returns BLUE-VERSION-1 | BLUE-VERSION-1 | PASS |
| Switch to Green | Service returns GREEN-VERSION-2 | GREEN-VERSION-2 | PASS |
| Rollback to Blue | Service returns BLUE-VERSION-1 | BLUE-VERSION-1 | PASS |

## Evidence Files
- `../evidence/01-deployment-status.txt` — deployment, pod, and Service status.
- `../evidence/02-blue-traffic.txt` — initial Blue traffic verification.
- `../evidence/03-green-traffic.txt` — Green traffic after switching.
- `../evidence/04-rollback-verification.txt` — traffic after rollback to Blue.

## Conclusion
Blue-green deployment and rollback were verified in the usecase14-lab namespace. The Service selector routed traffic to Blue, then Green, and finally back to Blue. Both application versions remained deployed during the switch.
