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
