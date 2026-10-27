# Use Case 14: Test Instructions

## Objective
Verify blue-green traffic switching and rollback using a Kubernetes Service.

## Prerequisites
- Blue and Green deployments are ready in namespace `usecase14-lab`.
- The `blue-green-service` Service exists.

## Test 1: Blue Version
Check that the Service initially selects Blue Pods:

```bash
kubectl get service blue-green-service -n usecase14-lab -o yaml
kubectl run blue-green-client --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n usecase14-lab -- curl -s http://blue-green-service
```

Expected response: `BLUE-VERSION-1`.

## Test 2: Switch to Green
```bash
kubectl patch service blue-green-service -n usecase14-lab -p '{"spec":{"selector":{"app":"blue-green-demo","version":"green"}}}'
kubectl run blue-green-client --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n usecase14-lab -- curl -s http://blue-green-service
```

Expected response: `GREEN-VERSION-2`.

## Test 3: Roll Back to Blue
```bash
kubectl patch service blue-green-service -n usecase14-lab -p '{"spec":{"selector":{"app":"blue-green-demo","version":"blue"}}}'
kubectl run blue-green-client --rm -i --restart=Never --image=curlimages/curl:8.12.1 -n usecase14-lab -- curl -s http://blue-green-service
```

Expected response: `BLUE-VERSION-1`.

## Pass Criteria
- Blue response is observed before switching.
- Green response is observed after switching.
- Blue response is restored after rollback.
- The Service endpoint points to ready Pods for the selected version.

## Evidence
Record actual command outputs in the `usecase14/evidence/` directory. Do not mark a test as passed until its observed result matches the expected response.
