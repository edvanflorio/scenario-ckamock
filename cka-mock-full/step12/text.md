## Task: Recover MariaDB with Persistent Volume

A user accidentally deleted the **MariaDB Deployment** and its **PVC** in the `mariadb` namespace. The data is preserved because the PV has `Retain` reclaim policy.

### Tasks

1. Inspect the retained PersistentVolume (only one PV exists)
2. **Clear the stale `claimRef`** on the PV so it becomes `Available` again
3. Create a **PVC** named **`mariadb`** in the `mariadb` namespace:
   - `accessModes: ReadWriteOnce`
   - `storage: 250Mi`
   - `storageClassName: ""` (empty — to bind to the existing PV)
4. Apply the deployment from **`~/mariadb-deploy.yaml`** (already contains the correct PVC reference)
5. Ensure the deployment is **running and stable**

### Inspect the current state

```plain
kubectl get pv
```{{exec}}

```plain
kubectl describe pv mariadb-pv
```{{exec}}

```plain
cat ~/mariadb-deploy.yaml
```{{exec}}

---

## Recover the MariaDB deployment

<details><summary>Tip: Releasing a Retained PV</summary>

When a PVC is deleted, the PV enters `Released` state — it still holds the old claim reference. You must remove the `claimRef` to make it `Available` again:

```plain
kubectl edit pv mariadb-pv
```{{exec}}

Remove the entire `claimRef:` section from the spec.

</details>

<details><summary>Solution</summary>

**Step 1 — Remove the stale claimRef from the PV:**
```plain
kubectl patch pv mariadb-pv --type=json -p='[{"op":"remove","path":"/spec/claimRef"}]'
```{{exec}}

```plain
kubectl get pv
```{{exec}}

**Step 2 — Create the PVC:**
```plain
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
  storageClassName: ""
EOF
```{{exec}}

```plain
kubectl get pvc -n mariadb
```{{exec}}

**Step 3 — Apply the deployment:**
```plain
kubectl apply -f ~/mariadb-deploy.yaml
```{{exec}}

```plain
kubectl rollout status deployment mariadb -n mariadb
```{{exec}}

</details>
