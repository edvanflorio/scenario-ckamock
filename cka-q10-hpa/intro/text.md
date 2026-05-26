## Task: Create a HorizontalPodAutoscaler (HPA)

An **apache-deployment** is running in the `autoscale` namespace.

### Tasks

Create a new **HorizontalPodAutoscaler** named **`apache-server`** in the `autoscale` namespace with:

1. **Target**: the `apache-deployment` deployment
2. **CPU utilization target**: `50%` per Pod
3. **Minimum replicas**: `1`
4. **Maximum replicas**: `4`
5. **Downscale stabilization window**: `30` seconds

### Inspect the deployment

```plain
kubectl get deployment apache-deployment -n autoscale
```{{exec}}

```plain
kubectl describe deployment apache-deployment -n autoscale | grep -A5 resources
```{{exec}}
