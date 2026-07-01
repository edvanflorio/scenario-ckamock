#!/bin/bash
set -e

echo "Simulating a cluster where Argo CD CRDs were already installed by a previous release..."

kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f - >/dev/null

helm template argocd argo-cd --repo https://argoproj.github.io/argo-helm --version 7.7.3 \
  --set crds.install=true --namespace argocd > /tmp/argocd-crds-only.yaml 2>/dev/null

awk '/^---/{n++} {print > ("/tmp/argocd-doc-" n ".yaml")}' /tmp/argocd-crds-only.yaml
for f in /tmp/argocd-doc-*.yaml; do
    grep -q "kind: CustomResourceDefinition" "$f" 2>/dev/null && kubectl apply -f "$f" >/dev/null 2>&1
done
rm -f /tmp/argocd-doc-*.yaml /tmp/argocd-crds-only.yaml

echo "Pre-installed Argo CD CRDs:"
kubectl get crd | grep argoproj.io || true
echo ""
echo "Lab setup complete! Helm is available on this node."
helm version --short 2>/dev/null || true
