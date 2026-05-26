## Congratulations!

You successfully created a PriorityClass and patched a Deployment to use it.

### Key Concepts

- **PriorityClass** defines the scheduling priority of Pods — higher values are scheduled first
- When nodes are under resource pressure, lower-priority Pods are preempted (evicted) to make room for higher-priority ones
- `kubectl patch` with a JSON merge patch is the most efficient way to modify a specific field

### Solution Reference

```bash
# Find highest user-defined priority
kubectl get priorityclass

# Create high-priority (one less than highest)
kubectl create priorityclass high-priority --value=999

# Patch the deployment
kubectl patch deployment -n priority busybox-logger \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```
