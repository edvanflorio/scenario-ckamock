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
