## Task: Select the Least Permissive NetworkPolicy

There are two deployments:
- **Frontend** (`frontend-deployment`) in the `frontend` namespace
- **Backend** (`backend-deployment`) in the `backend` namespace

The goal is to allow frontend pods to reach backend pods **with minimum permissions**.

### Task

1. Inspect the three NetworkPolicy YAML files in `/root/network-policies/`
2. Identify which policy allows frontend→backend communication with the **least permissive** rules
3. **Apply** that policy to the cluster

```plain
ls /root/network-policies/
```{{exec}}

```plain
cat /root/network-policies/network-policy-1.yaml
```{{exec}}

```plain
cat /root/network-policies/network-policy-2.yaml
```{{exec}}

```plain
cat /root/network-policies/network-policy-3.yaml
```{{exec}}

Check frontend pod labels:
```plain
kubectl get pods -n frontend --show-labels
```{{exec}}
