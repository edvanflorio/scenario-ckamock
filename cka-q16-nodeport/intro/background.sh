#!/bin/bash
set -e

kubectl create namespace relative --dry-run=client -o yaml | kubectl apply -f - >/dev/null

kubectl -n relative create deployment nodeport-deployment \
  --image=nginx --replicas=2 --dry-run=client -o yaml | kubectl apply -f - >/dev/null

echo "Lab setup complete!"
echo ""
kubectl get deployment nodeport-deployment -n relative
