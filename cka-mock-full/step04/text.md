## Task: Configure Pod Resource Requests and Limits

A **wordpress** deployment is running with 3 replicas. You must assign fair CPU and memory resources to each pod based on what the node can provide.

### Tasks

1. **Scale down** the `wordpress` deployment to **0 replicas**
2. Inspect the node's **allocatable** CPU and memory
3. **Divide the node resources evenly** across the 3 pods (subtract existing usage and leave ~10% headroom)
4. Edit the deployment to set **equal `requests` and `limits`** for CPU and memory on:
   - The **main container** (`wordpress`)
   - The **init container** (`init-setup`)
   - Both must use **exactly the same** values
5. **Scale back up** to **3 replicas**

### Inspect the node

```plain
kubectl describe node | grep -A5 "Allocatable:"
```{{exec}}

```plain
kubectl describe node | grep -A20 "Resource requests"
```{{exec}}

---

## Set resource requests and limits

Complete all tasks and click **Check** to validate.

<details><summary>Tip: Calculating fair resources</summary>

1. Find allocatable CPU and memory:
```plain
kubectl describe node | grep -A5 "Allocatable:"
```{{exec}}

2. Find currently requested resources:
```plain
kubectl describe node | grep -A30 "Resource requests"
```{{exec}}

3. Subtract current usage and ~10% headroom, then divide by 3.
4. Round to sensible values (e.g., 250m CPU, 500Mi memory).

</details>

<details><summary>Solution</summary>

**Scale down:**
```plain
kubectl scale deployment wordpress --replicas=0
```{{exec}}

**Edit the deployment** (add resources to BOTH initContainers and containers):
```plain
kubectl edit deployment wordpress
```{{exec}}

Add this block to BOTH the `initContainers[0]` and `containers[0]` sections:
```plain
resources:
  requests:
    cpu: "250m"
    memory: "500Mi"
  limits:
    cpu: "300m"
    memory: "600Mi"
```{{copy}}

> Adjust the values based on your node's actual allocatable resources.

**Scale back up:**
```plain
kubectl scale deployment wordpress --replicas=3
```{{exec}}

**Verify:**
```plain
kubectl rollout status deployment wordpress
```{{exec}}

```plain
kubectl describe deployment wordpress | grep -A8 "Limits"
```{{exec}}

</details>
