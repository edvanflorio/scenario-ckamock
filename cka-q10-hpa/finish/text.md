## Congratulations!

You successfully created a HorizontalPodAutoscaler with CPU-based scaling.

### Key Concepts

- **HPA** automatically scales Pod replicas based on observed metrics (CPU, memory, custom)
- **`autoscaling/v2`** supports multiple metrics and fine-grained behavior configuration
- **`stabilizationWindowSeconds`** prevents flapping — the HPA waits before scaling down
- The Pod must have `resources.requests.cpu` defined for CPU-based HPA to work

### Solution Reference

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
```
