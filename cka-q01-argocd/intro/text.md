## Task: Helm — Install Argo CD without reinstalling CRDs

You have access to a Kubernetes cluster with Helm installed.

> **Context:** The `argocd` namespace and the Argo CD CRDs already exist in this cluster, installed by a previous release. Your job is to **actually install** Argo CD via Helm without touching those existing CRDs.

### Tasks

1. Add the official Argo CD Helm repository named **argocd**
   - URL: `https://argoproj.github.io/argo-helm`
2. Install (not just template) the Argo CD chart, **version 7.7.3**, as release `argocd` in namespace `argocd`
3. Ensure CRDs are **NOT** reinstalled by setting the correct chart parameter, since they already exist in the cluster
4. Confirm the release is deployed and the core Argo CD workloads are running
