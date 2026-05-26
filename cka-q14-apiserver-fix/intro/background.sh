#!/bin/bash
set -e

echo "Simulating post-migration misconfiguration..."

# Backup current manifest
cp /etc/kubernetes/manifests/kube-apiserver.yaml /root/kube-apiserver.yaml.bak

# Change etcd client port to peer port (the bug)
sed -i 's/:2379/:2380/g' /etc/kubernetes/manifests/kube-apiserver.yaml

echo "Misconfiguration applied. Waiting for kube-apiserver to fail..."
sleep 20

echo ""
echo "Checking API server status..."
kubectl get nodes 2>&1 || echo "API server is down — as expected after misconfiguration."
echo ""
echo "Your task: fix the kube-apiserver manifest so the cluster recovers."
