## Task: Helm — Install Argo CD without CRDs

You have access to a Kubernetes cluster with Helm installed.

### Tasks

1. Add the official Argo CD Helm repository named **argocd**
   - URL: `https://argoproj.github.io/argo-helm`
2. Generate a Helm **template** from the Argo CD chart **version 7.7.3** targeting namespace `argocd`
3. Ensure **CRDs are NOT installed** by setting the correct chart parameter
4. Save the generated YAML manifest to `/root/argo-helm.yaml`

> **Note:** Do not actually install Argo CD into the cluster — only generate the template and save it.
