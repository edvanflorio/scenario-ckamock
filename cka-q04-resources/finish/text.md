## Congratulations!

You successfully configured fair and equal resource requests and limits for a multi-replica deployment.

### Key Concepts

- **requests**: the minimum guaranteed resources — used by the scheduler to select nodes
- **limits**: the maximum resources a container can use — enforced by the kubelet
- Init containers must also have resources defined; they run sequentially before main containers

### Workflow Reference

```bash
# 1. Scale down
kubectl scale deployment wordpress --replicas=0

# 2. Find allocatable resources
kubectl describe node | grep -A5 "Allocatable:"

# 3. Find already requested resources
kubectl describe node | grep -A30 "Resource requests"

# 4. Edit the deployment (both containers)
kubectl edit deployment wordpress

# 5. Scale back up
kubectl scale deployment wordpress --replicas=3
```
