## Task: Configure a NodePort Service

There is a deployment named **`nodeport-deployment`** in the **`relative`** namespace.

### Tasks

1. **Edit the deployment** to declare the container port:
   - Port: `80`
   - Name: `http`
   - Protocol: `TCP`

2. Create a **Service** named **`nodeport-service`** in the `relative` namespace:
   - Type: `NodePort`
   - Port: `80`
   - Target Port: `80`
   - NodePort: `30080`

3. Confirm the Service exposes the **individual pods** (endpoints are populated)

### Inspect the deployment

```plain
kubectl get deployment nodeport-deployment -n relative
```{{exec}}

```plain
kubectl describe deployment nodeport-deployment -n relative | grep -A5 Containers
```{{exec}}
