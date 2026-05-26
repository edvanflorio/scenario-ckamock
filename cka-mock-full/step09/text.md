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

---

## Analyse and deploy the correct NetworkPolicy

<details><summary>Tip: Evaluating permissiveness</summary>

Compare the three policies:

- **policy-x**: `podSelector: {}` + `ingress: [{}]` — allows **ALL** ingress traffic to ALL pods → most permissive
- **policy-y**: allows frontend namespace + an additional `ipBlock: 172.16.0.0/16` — more permissive than needed
- **policy-z**: allows only traffic from pods labelled `app: frontend` in the `frontend` namespace on port 80 → **least permissive**

Check frontend pod labels to confirm they match `policy-z`'s selector:
```plain
kubectl get pods -n frontend --show-labels
```{{exec}}

</details>

<details><summary>Solution</summary>

The correct policy is **policy-z** (`network-policy-3.yaml`):

```plain
kubectl apply -f /root/network-policies/network-policy-3.yaml
```{{exec}}

**Verify:**
```plain
kubectl get networkpolicy -n backend
```{{exec}}

```plain
kubectl describe networkpolicy policy-z -n backend
```{{exec}}

</details>
