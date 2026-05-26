## Congratulations!

You successfully recovered a MariaDB deployment by reusing an existing retained PersistentVolume.

### Key Concepts

- **`Retain` reclaim policy**: The PV is not deleted when the PVC is deleted — data is preserved
- **`Released` state**: The PV is no longer bound but still holds the old `claimRef` — you must remove it
- **`storageClassName: ""`**: An empty storage class name binds to PVs with no storage class

### Workflow Reference

```bash
# 1. Inspect the PV
kubectl describe pv mariadb-pv

# 2. Remove the stale claimRef
kubectl patch pv mariadb-pv --type=json -p='[{"op":"remove","path":"/spec/claimRef"}]'

# 3. Create the PVC with matching spec
kubectl apply -f pvc.yaml

# 4. Apply the deployment
kubectl apply -f ~/mariadb-deploy.yaml
```
