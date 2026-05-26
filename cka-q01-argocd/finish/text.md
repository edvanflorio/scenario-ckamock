## Congratulations!

You successfully configured Helm to install Argo CD without its CRDs.

### Key Concepts

- In production clusters, CRDs are often pre-installed (e.g., via cluster bootstrap tools). Using `--set crds.install=false` avoids conflicts when re-deploying or upgrading charts.
- `helm template` renders Kubernetes manifests without applying them — useful for auditing or GitOps workflows.

### Solution Reference

```plain
helm repo add argocd https://argoproj.github.io/argo-helm
helm template argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd > /root/argo-helm.yaml
```

### CKA Exam Tips
- The exam often specifies an exact chart version — always use `--version`
- Use `helm repo update` if the chart version is not found after adding the repo
