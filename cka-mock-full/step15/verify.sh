#!/bin/bash
set -e

DEPLOYMENT="nodeport-deployment"
SERVICE="nodeport-service"
EXPECTED_NODEPORT="30080"
EXPECTED_PORT="80"

echo "Starting NodePort validation..."

NS=$(kubectl get deploy -A --no-headers | awk -v dep="$DEPLOYMENT" '$2==dep {print $1}')
if [ -z "$NS" ]; then
  echo "FAIL: Deployment $DEPLOYMENT not found"
  exit 1
fi
echo "PASS: Deployment found in namespace: $NS"

kubectl get deploy "$DEPLOYMENT" -n "$NS" -o yaml | grep -q "containerPort: 80" \
  || { echo "FAIL: containerPort 80 not found"; exit 1; }
kubectl get deploy "$DEPLOYMENT" -n "$NS" -o yaml | grep -q "name: http" \
  || { echo "FAIL: port name http not found"; exit 1; }
kubectl get deploy "$DEPLOYMENT" -n "$NS" -o yaml | grep -q "protocol: TCP" \
  || { echo "FAIL: protocol TCP not found"; exit 1; }
echo "PASS: Deployment exposes port 80/http/TCP"

kubectl get svc "$SERVICE" -n "$NS" >/dev/null 2>&1 \
  || { echo "FAIL: Service $SERVICE not found"; exit 1; }
echo "PASS: Service exists"

TYPE=$(kubectl get svc "$SERVICE" -n "$NS" -o jsonpath='{.spec.type}')
NODEPORT=$(kubectl get svc "$SERVICE" -n "$NS" -o jsonpath='{.spec.ports[0].nodePort}')
PORT=$(kubectl get svc "$SERVICE" -n "$NS" -o jsonpath='{.spec.ports[0].port}')
TARGETPORT=$(kubectl get svc "$SERVICE" -n "$NS" -o jsonpath='{.spec.ports[0].targetPort}')

[ "$TYPE" = "NodePort" ] || { echo "FAIL: Service is not NodePort"; exit 1; }
[ "$NODEPORT" = "$EXPECTED_NODEPORT" ] || { echo "FAIL: nodePort=$NODEPORT (expected $EXPECTED_NODEPORT)"; exit 1; }
[ "$PORT" = "$EXPECTED_PORT" ] || { echo "FAIL: port=$PORT (expected $EXPECTED_PORT)"; exit 1; }
[ "$TARGETPORT" = "$EXPECTED_PORT" ] || { echo "FAIL: targetPort=$TARGETPORT (expected $EXPECTED_PORT)"; exit 1; }
echo "PASS: Service ports correctly configured"

ENDPOINTS=$(kubectl get endpoints "$SERVICE" -n "$NS" -o jsonpath='{.subsets[*].addresses[*].ip}')
if [ -z "$ENDPOINTS" ]; then
  echo "FAIL: Service has no active endpoints (no pods exposed)"
  exit 1
fi
COUNT=$(echo "$ENDPOINTS" | wc -w)
echo "PASS: Service exposes $COUNT pod endpoint(s)"

echo "SUCCESS: NodePort configuration is VALID"
