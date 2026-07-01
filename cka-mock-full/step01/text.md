## Task: Helm — Install Argo CD without reinstalling CRDs

You have access to a Kubernetes cluster with Helm installed.

> **Context:** The `argocd` namespace and the Argo CD CRDs already exist in this cluster, installed by a previous release. Your job is to **actually install** Argo CD via Helm without touching those existing CRDs.

### Tasks

1. Add the official Argo CD Helm repository named **argocd**
   - URL: `https://argoproj.github.io/argo-helm`
2. Install (not just template) the Argo CD chart, **version 7.7.3**, as release `argocd` in namespace `argocd`
3. Ensure CRDs are **NOT** reinstalled by setting the correct chart parameter, since they already exist in the cluster
4. Confirm the release is deployed and the core Argo CD workloads are running

---

## Install Argo CD via Helm (CRDs already present)

Complete all tasks and click **Check** to validate.

### Useful references
- `helm repo add <name> <url>` — adds a Helm repository
- `helm repo list` — lists configured repositories
- `helm install <release> <chart> --version <ver> --set <key>=<val> --namespace <ns>` — installs the chart into the cluster

<details><summary>Tip: Disabling CRD installation</summary>

The Argo CD chart uses the value `crds.install` to control CRD creation.
Since the CRDs are already present in this cluster, set it to `false` to avoid reinstalling/conflicting with them:

```plain
helm install argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — Add the Argo CD Helm repository:**
```plain
helm repo add argocd https://argoproj.github.io/argo-helm
```{{exec}}

**Step 2 — Verify the repo is listed:**
```plain
helm repo list
```{{exec}}

**Step 3 — Update the repo cache:**
```plain
helm repo update
```{{exec}}

**Step 4 — Install Argo CD into the cluster without touching existing CRDs:**
```plain
helm install argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd
```{{exec}}

**Step 5 — Verify the release and workloads:**
```plain
helm list -n argocd
kubectl get pods -n argocd
```{{exec}}

</details>
