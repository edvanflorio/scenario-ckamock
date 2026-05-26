## Install Argo CD via Helm (no CRDs)

Complete all four tasks and click **Check** to validate.

### Useful references
- `helm repo add <name> <url>` — adds a Helm repository
- `helm repo list` — lists configured repositories
- `helm template <release> <chart> --version <ver> --set <key>=<val> --namespace <ns>` — renders templates without installing

<details><summary>Tip: Disabling CRD installation</summary>

The Argo CD chart uses the value `crds.install` to control CRD creation.
Set it to `false` to skip CRD installation:

```plain
helm template argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd
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

**Step 3 — Generate the template without CRDs and save it:**
```plain
helm template argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd > /root/argo-helm.yaml
```{{exec}}

**Step 4 — Verify the file was created and contains no CRDs:**
```plain
grep -c "kind:" /root/argo-helm.yaml && grep "CustomResourceDefinition" /root/argo-helm.yaml || echo "No CRDs found — correct!"
```{{exec}}

</details>
