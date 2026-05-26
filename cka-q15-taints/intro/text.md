## Task: Taints and Tolerations

You have a two-node Kubernetes cluster (controlplane + node01).

### Tasks

1. Add a **taint** to **node01** so that no normal pods can be scheduled there:
   - Key: `PERMISSION`
   - Value: `granted`
   - Effect: `NoSchedule`

2. **Schedule a Pod** on node01 by adding the correct **toleration** to the Pod spec

### Inspect the cluster

```plain
kubectl get nodes
```{{exec}}

```plain
kubectl describe node node01 | grep Taints
```{{exec}}
