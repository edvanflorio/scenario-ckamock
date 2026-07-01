#!/bin/bash
set -e

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"

echo "Validating control plane recovery after the broken kubeadm upgrade..."

if ! kubectl get nodes &>/dev/null; then
  echo "FAIL: Cannot reach the Kubernetes API server. The fix may not be applied yet."
  exit 1
fi
echo "PASS: Kubernetes API server is reachable."

CERTFILE=$(sudo grep -oP '(?<=--etcd-certfile=)\S+' "$MANIFEST" 2>/dev/null || true)
KEYFILE=$(sudo grep -oP '(?<=--etcd-keyfile=)\S+' "$MANIFEST" 2>/dev/null || true)

if [[ -z "$CERTFILE" || ! -f "$CERTFILE" ]]; then
  echo "FAIL: kube-apiserver manifest references a missing etcd client cert: ${CERTFILE:-<none>}"
  exit 1
fi
echo "PASS: etcd client cert file exists at $CERTFILE"

if [[ -z "$KEYFILE" || ! -f "$KEYFILE" ]]; then
  echo "FAIL: kube-apiserver manifest references a missing etcd client key: ${KEYFILE:-<none>}"
  exit 1
fi
echo "PASS: etcd client key file exists at $KEYFILE"

for component in kube-apiserver kube-controller-manager kube-scheduler etcd; do
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
