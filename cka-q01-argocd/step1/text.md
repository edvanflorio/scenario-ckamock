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
