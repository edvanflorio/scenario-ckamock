## Task: Create and Set Default StorageClass

### Tasks

1. Create a new **StorageClass** named **`local-storage`** with:
   - Provisioner: `rancher.io/local-path`
   - VolumeBindingMode: `WaitForFirstConsumer`
   - **Do NOT** mark it as default initially

2. **Patch** the StorageClass to make it the **default** StorageClass

3. Ensure **`local-storage` is the only default** StorageClass (remove default annotation from any other SC)

> Do not modify any existing Deployments or PersistentVolumeClaims.

### Inspect the cluster

```plain
kubectl get sc
```{{exec}}
