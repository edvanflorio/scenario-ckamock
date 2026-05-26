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
