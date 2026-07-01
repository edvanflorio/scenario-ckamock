## Congratulations!

You successfully installed Argo CD via Helm without touching the CRDs already present in the cluster.

### Key Concepts

- In production clusters, CRDs are often pre-installed (e.g., via cluster bootstrap tools or a previous release). Using `--set crds.install=false` lets you install/upgrade the chart without conflicting with those existing CRDs.
- `helm template` only renders manifests locally — it never touches the cluster. When the task actually requires the workload running, use `helm install` (or `helm upgrade --install`).

### Solution Reference

```plain
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd
```

### CKA Exam Tips
- The exam often specifies an exact chart version — always use `--version`
- Use `helm repo update` if the chart version is not found after adding the repo
- Read the task carefully: "generate a template" and "install" are different actions — don't assume one when the other is asked
