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

---

## Create and configure the StorageClass

<details><summary>Tip: StorageClass YAML structure</summary>

```plain
kubectl explain storageclass
```{{exec}}

The `storageclass.kubernetes.io/is-default-class` annotation controls the default status.

</details>

<details><summary>Solution</summary>

**Step 1 — Create the StorageClass:**
```plain
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
EOF
```{{exec}}

**Step 2 — Patch local-storage to be default:**
```plain
kubectl patch storageclass local-storage -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```{{exec}}

**Step 3 — Remove default from any other SC (e.g., local-path):**
```plain
kubectl get sc
```{{exec}}

```plain
kubectl patch storageclass local-path -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```{{exec}}

**Step 4 — Verify:**
```plain
kubectl get sc
```{{exec}}

</details>
