#!/bin/bash
set -e

echo "Simulating a broken kubeadm upgrade..."

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
cp "$MANIFEST" /root/kube-apiserver.yaml.bak

# Portable extraction (no PCRE lookbehind) so this doesn't silently no-op
# on grep builds without -P support.
CERTFILE=$(sed -n 's/.*--etcd-certfile=\([^[:space:]"]*\).*/\1/p' "$MANIFEST" | head -1)
KEYFILE=$(sed -n 's/.*--etcd-keyfile=\([^[:space:]"]*\).*/\1/p' "$MANIFEST" | head -1)

if [ -z "$CERTFILE" ] || [ -z "$KEYFILE" ]; then
  echo "ERROR: could not find --etcd-certfile/--etcd-keyfile in $MANIFEST" >&2
  exit 1
fi

if [ ! -f "$CERTFILE" ] || [ ! -f "$KEYFILE" ]; then
  echo "ERROR: etcd client cert/key not found at expected paths ($CERTFILE / $KEYFILE)" >&2
  exit 1
fi

# Simulate the upgrade renaming the etcd client certs without updating the
# kube-apiserver manifest to match. kube-apiserver can no longer read its
# etcd client cert/key and crashes on startup.
mv "$CERTFILE" "${CERTFILE}.upgraded"
mv "$KEYFILE" "${KEYFILE}.upgraded"

# Force an immediate restart instead of waiting on kubelet's own resync interval.
crictl rm -f $(crictl ps -q --name kube-apiserver) >/dev/null 2>&1 || true

echo "Waiting for kube-apiserver to crash (and controller-manager/scheduler to follow)..."
for i in $(seq 1 25); do
  kubectl get nodes &>/dev/null || break
  sleep 1
done

echo ""
echo "Cluster status right now:"
kubectl get nodes 2>&1 || echo "API server is unreachable — as expected after the broken upgrade."
echo ""
echo "Your task: diagnose why the control plane is unhealthy and restore it."
