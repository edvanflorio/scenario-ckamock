#!/bin/bash
set -e

NAMESPACE="tigera-operator"

echo "Validating Calico CNI installation..."

if ! kubectl get namespace "$NAMESPACE" &>/dev/null; then
  echo "FAIL: Namespace '$NAMESPACE' not found. Calico does not appear to be installed."
  exit 1
fi
echo "PASS: Namespace '$NAMESPACE' exists."

if ! kubectl get deployment tigera-operator -n "$NAMESPACE" &>/dev/null; then
  echo "FAIL: Deployment 'tigera-operator' not found in namespace '$NAMESPACE'."
  exit 1
fi
echo "PASS: Deployment 'tigera-operator' found."

available=$(kubectl get deployment tigera-operator -n "$NAMESPACE" \
  -o jsonpath='{.status.availableReplicas}')
if [[ "${available:-0}" -lt 1 ]]; then
  echo "FAIL: tigera-operator deployment has no available replicas."
  exit 1
fi
echo "PASS: tigera-operator deployment is available ($available replica(s) ready)."

failed=$(kubectl get pods -n "$NAMESPACE" \
  --field-selector=status.phase=Failed --no-headers 2>/dev/null | wc -l)
if [[ "$failed" -gt 0 ]]; then
  echo "FAIL: There are failed pods in namespace '$NAMESPACE'."
  kubectl get pods -n "$NAMESPACE"
  exit 1
fi
echo "PASS: No failed pods in namespace '$NAMESPACE'."

echo "SUCCESS: Calico CNI installation validated!"
exit 0
