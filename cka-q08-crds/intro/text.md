## Task: Work with Custom Resource Definitions (CRDs)

cert-manager CRDs are installed in the cluster.

### Tasks

1. List all **cert-manager CRDs** and save the output to `/root/resources.yaml`

2. Use `kubectl explain` to extract the **documentation for `Certificate.spec.subject`** and save it to `/root/subject.yaml`

> You may use any output format that `kubectl` supports.

### Inspect the CRDs

```plain
kubectl get crd | grep cert-manager
```{{exec}}

```plain
kubectl api-resources | grep cert-manager
```{{exec}}
