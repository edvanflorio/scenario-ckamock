## Create the HPA resource

<details><summary>Tip: HPA API version</summary>

Use `autoscaling/v2` for full feature support including behavior configuration:

```plain
kubectl explain hpa --api-version=autoscaling/v2
```{{exec}}

```plain
kubectl explain hpa.spec.behavior --api-version=autoscaling/v2
```{{exec}}

</details>

<details><summary>Solution</summary>

```plain
cat <<EOF | kubectl apply -f -
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
EOF
```{{exec}}

**Verify:**
```plain
kubectl get hpa -n autoscale
```{{exec}}

```plain
kubectl describe hpa apache-server -n autoscale
```{{exec}}

</details>
