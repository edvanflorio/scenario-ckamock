#!/bin/bash
set -e

echo "Simulating a broken kubeadm upgrade..."

MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
cp "$MANIFEST" /root/kube-apiserver.yaml.bak

CERTFILE=$(grep -oP '(?<=--etcd-certfile=)\S+' "$MANIFEST")
KEYFILE=$(grep -oP '(?<=--etcd-keyfile=)\S+' "$MANIFEST")

# Simulate the upgrade renaming the etcd client certs without updating the
# kube-apiserver manifest to match. kube-apiserver can no longer read its
# etcd client cert/key and crashes on startup.
if [ -f "$CERTFILE" ] && [ -f "$KEYFILE" ]; then
  mv "$CERTFILE" "${CERTFILE}.upgraded"
  mv "$KEYFILE" "${KEYFILE}.upgraded"
fi

echo "Waiting for kube-apiserver to crash (and controller-manager/scheduler to follow)..."
sleep 25

echo ""
echo "Cluster status right now:"
kubectl get nodes 2>&1 || echo "API server is unreachable — as expected after the broken upgrade."
echo ""
echo "Your task: diagnose why the control plane is unhealthy and restore it."
