## Congratulations!

You successfully created a StorageClass and configured it as the sole default.

### Key Concepts

- **WaitForFirstConsumer** delays volume binding until a Pod is scheduled, allowing the volume to be provisioned in the same availability zone as the Pod
- Only **one** StorageClass should be the default — multiple defaults cause PVC binding failures
- The `kubectl patch` command is the standard exam approach to modify annotations

### Solution Reference

```bash
# Create StorageClass
kubectl apply -f sc.yaml

# Patch to make default
kubectl patch storageclass local-storage \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Remove default from old SC
kubectl patch storageclass local-path \
  -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```
