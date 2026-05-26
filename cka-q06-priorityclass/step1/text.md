## Create PriorityClass and patch the deployment

<details><summary>Tip: Finding the highest user-defined PriorityClass</summary>

System PriorityClasses (`system-cluster-critical`, `system-node-critical`) should be excluded. Find the highest value among user-defined ones:

```plain
kubectl get priorityclass --no-headers | grep -v system | sort -k2 -rn
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — Find the highest user-defined value:**
```plain
kubectl get pc
```{{exec}}

The `user-critical` class has value 1000. So `high-priority` should be 999.

**Step 2 — Create the PriorityClass:**
```plain
kubectl create priorityclass high-priority --value=999 --description="high priority"
```{{exec}}

**Step 3 — Patch the deployment:**
```plain
kubectl patch deployment -n priority busybox-logger \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```{{exec}}

**Step 4 — Verify:**
```plain
kubectl describe deployment -n priority busybox-logger | grep -i priority
```{{exec}}

```plain
kubectl get priorityclass
```{{exec}}

</details>
