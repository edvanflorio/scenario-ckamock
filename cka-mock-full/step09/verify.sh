#!/bin/bash
set -e

NAMESPACE="backend"
EXPECTED_POLICY="policy-z"
EXPECTED_PORT="80"

echo "Validating NetworkPolicy selection (least permissive)..."

kubectl get networkpolicy "$EXPECTED_POLICY" -n "$NAMESPACE" >/dev/null 2>&1 \
  || { echo "FAIL: NetworkPolicy $EXPECTED_POLICY not found in $NAMESPACE"; exit 1; }
echo "PASS: policy-z exists"

BACKEND_SELECTOR=$(kubectl get networkpolicy "$EXPECTED_POLICY" -n "$NAMESPACE" \
  -o jsonpath='{.spec.podSelector.matchLabels.app}')
[ "$BACKEND_SELECTOR" = "backend" ] \
  || { echo "FAIL: podSelector does not target backend pods"; exit 1; }
echo "PASS: Targets backend pods only"

NS_SELECTOR=$(kubectl get networkpolicy "$EXPECTED_POLICY" -n "$NAMESPACE" \
  -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.kubernetes\.io/metadata\.name}')
[ "$NS_SELECTOR" = "frontend" ] \
  || { echo "FAIL: Ingress not restricted to frontend namespace"; exit 1; }
echo "PASS: Restricted to frontend namespace"

POD_SELECTOR=$(kubectl get networkpolicy "$EXPECTED_POLICY" -n "$NAMESPACE" \
  -o jsonpath='{.spec.ingress[0].from[1].podSelector.matchLabels.app}')
[ "$POD_SELECTOR" = "frontend" ] \
  || { echo "FAIL: Ingress not restricted to frontend pods"; exit 1; }
echo "PASS: Restricted to frontend pods"

PORT=$(kubectl get networkpolicy "$EXPECTED_POLICY" -n "$NAMESPACE" \
  -o jsonpath='{.spec.ingress[0].ports[0].port}')
[ "$PORT" = "$EXPECTED_PORT" ] \
  || { echo "FAIL: Port $PORT configured (expected $EXPECTED_PORT)"; exit 1; }
echo "PASS: Port 80 restriction enforced"

BAD_POLICIES=$(kubectl get networkpolicy -n "$NAMESPACE" \
  --no-headers | awk '{print $1}' | grep -E 'policy-x|policy-y' || true)
[ -z "$BAD_POLICIES" ] \
  || { echo "FAIL: Overly permissive NetworkPolicy detected: $BAD_POLICIES"; exit 1; }
echo "PASS: No overly permissive policies present"

echo "SUCCESS: Least-permissive NetworkPolicy correctly deployed"
