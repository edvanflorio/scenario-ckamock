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

---

## Taint the node and deploy a tolerating Pod

<details><summary>Tip: Adding a taint</summary>

```plain
kubectl taint nodes node01 PERMISSION=granted:NoSchedule
```{{exec}}

Verify:
```plain
kubectl describe node node01 | grep Taints
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — Add the taint to node01:**
```plain
kubectl taint nodes node01 PERMISSION=granted:NoSchedule
```{{exec}}

**Step 2 — Create a Pod with the matching toleration:**
```plain
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: tolerating-pod
  labels:
    env: test
spec:
  nodeName: node01
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  tolerations:
  - key: "PERMISSION"
    operator: "Equal"
    value: "granted"
    effect: "NoSchedule"
EOF
```{{exec}}

**Step 3 — Verify the Pod is scheduled on node01:**
```plain
kubectl get pod tolerating-pod -o wide
```{{exec}}

**Step 4 — Test that a Pod without toleration stays Pending:**
```plain
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: no-toleration-pod
spec:
  containers:
  - name: nginx
    image: nginx
EOF
```{{exec}}

```plain
kubectl get pods -o wide
```{{exec}}

```plain
kubectl describe pod no-toleration-pod | grep -A5 Events
```{{exec}}

</details>
