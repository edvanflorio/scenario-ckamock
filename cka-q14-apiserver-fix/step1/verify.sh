#!/bin/bash
set -e

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
CORRECT_PORT="2379"
WRONG_PORT="2380"

echo "Validating etcd port misconfiguration fix..."

if ! kubectl get nodes &>/dev/null; then
  echo "FAIL: Cannot reach the Kubernetes API server. The fix may not be applied yet."
  exit 1
fi
echo "PASS: Kubernetes API server is reachable."

apiserver_phase=$(kubectl get pod -n kube-system \
  -l component=kube-apiserver \
  -o jsonpath='{.items[0].status.phase}' 2>/dev/null || true)

if [[ "$apiserver_phase" != "Running" ]]; then
  echo "FAIL: kube-apiserver pod is not Running (phase: ${apiserver_phase:-not found})."
  exit 1
fi
echo "PASS: kube-apiserver pod is Running."

if sudo grep -q ":$WRONG_PORT" "$MANIFEST" 2>/dev/null; then
  echo "FAIL: kube-apiserver manifest still contains port $WRONG_PORT for etcd."
  exit 1
fi
echo "PASS: kube-apiserver manifest does not contain the incorrect port $WRONG_PORT."

if ! sudo grep -q ":$CORRECT_PORT" "$MANIFEST" 2>/dev/null; then
  echo "FAIL: kube-apiserver manifest does not reference the correct etcd port $CORRECT_PORT."
  exit 1
fi
echo "PASS: kube-apiserver manifest uses the correct etcd port $CORRECT_PORT."

for component in kube-apiserver kube-controller-manager kube-scheduler; do
  phase=$(kubectl get pod -n kube-system \
    -l component="$component" \
    -o jsonpath='{.items[0].status.phase}' 2>/dev/null || true)
  if [[ "$phase" != "Running" ]]; then
    echo "FAIL: Control plane component '$component' is not Running (phase: ${phase:-not found})."
    exit 1
  fi
  echo "PASS: $component is Running."
done

echo "SUCCESS: All validations passed!"
exit 0
