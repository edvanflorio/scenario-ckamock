#!/bin/bash
set -e

echo "Installing cert-manager CRDs..."
kubectl create ns cert-manager --dry-run=client -o yaml | kubectl apply -f - >/dev/null

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.0/cert-manager.crds.yaml >/dev/null 2>&1

echo "Lab setup complete!"
echo ""
echo "Installed cert-manager CRDs:"
kubectl get crd | grep cert-manager
