## Task: Install a CNI Plugin

You must install a CNI (Container Network Interface) that meets all of the following requirements:

1. **Pods can communicate with each other**
2. **Supports NetworkPolicy enforcement**
3. **Installed from a manifest file** (not Helm)

### Options

| CNI | NetworkPolicy Support | Install method |
|-----|-----------------------|----------------|
| **Flannel v0.26.1** | ❌ No | manifest: `kube-flannel.yml` |
| **Calico v3.28.2** | ✅ Yes | manifest: `tigera-operator.yaml` |

> **Hint**: The requirement to support NetworkPolicy enforcement eliminates one of the options.

### Inspect the cluster

```plain
kubectl get nodes
```{{exec}}

```plain
kubectl get pods -n kube-system
```{{exec}}
