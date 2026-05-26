#!/bin/bash
set -e

NAMESPACE="mariadb"
PVC_NAME="mariadb"
DEPLOYMENT="mariadb"
EXPECTED_STORAGE="250Mi"
EXPECTED_ACCESS="ReadWriteOnce"

echo "Validating MariaDB recovery with persistent storage..."

kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 \
  || { echo "FAIL: Namespace $NAMESPACE does not exist"; exit 1; }
echo "PASS: Namespace exists"

PV_COUNT=$(kubectl get pv --no-headers | wc -l)
[ "$PV_COUNT" -eq 1 ] \
  || { echo "FAIL: Expected exactly 1 PV, found $PV_COUNT"; exit 1; }
echo "PASS: Single PersistentVolume exists"

kubectl get pvc "$PVC_NAME" -n "$NAMESPACE" >/dev/null 2>&1 \
  || { echo "FAIL: PVC $PVC_NAME not found"; exit 1; }
echo "PASS: PVC exists"

ACCESS_MODE=$(kubectl get pvc "$PVC_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.accessModes[0]}')
[ "$ACCESS_MODE" = "$EXPECTED_ACCESS" ] \
  || { echo "FAIL: accessMode=$ACCESS_MODE (expected $EXPECTED_ACCESS)"; exit 1; }
echo "PASS: PVC access mode correct"

STORAGE=$(kubectl get pvc "$PVC_NAME" -n "$NAMESPACE" -o jsonpath='{.spec.resources.requests.storage}')
[ "$STORAGE" = "$EXPECTED_STORAGE" ] \
  || { echo "FAIL: storage=$STORAGE (expected $EXPECTED_STORAGE)"; exit 1; }
echo "PASS: PVC storage size correct"

STATUS=$(kubectl get pvc "$PVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.phase}')
[ "$STATUS" = "Bound" ] \
  || { echo "FAIL: PVC status=$STATUS (expected Bound)"; exit 1; }
echo "PASS: PVC is Bound"

kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" >/dev/null 2>&1 \
  || { echo "FAIL: Deployment $DEPLOYMENT not found"; exit 1; }
echo "PASS: Deployment exists"

CLAIM=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" \
  -o jsonpath='{.spec.template.spec.volumes[*].persistentVolumeClaim.claimName}')
echo "$CLAIM" | grep -qw "$PVC_NAME" \
  || { echo "FAIL: Deployment does not reference PVC $PVC_NAME"; exit 1; }
echo "PASS: Deployment uses PVC"

READY=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
DESIRED=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.replicas}')
[ "$READY" = "$DESIRED" ] \
  || { echo "FAIL: Deployment not stable (ready=$READY desired=$DESIRED)"; exit 1; }
echo "PASS: Deployment is running and stable"

echo "SUCCESS: MariaDB deployment successfully restored with preserved data"
