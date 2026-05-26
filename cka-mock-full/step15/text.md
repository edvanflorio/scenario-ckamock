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

---

## Configure the deployment port and create the Service

<details><summary>Tip: Adding a named port to a deployment</summary>

Edit the deployment and find the container spec. Add a `ports` section:

```plain
kubectl edit deployment nodeport-deployment -n relative
```{{exec}}

Add under `containers[0]`:
```plain
ports:
- name: http
  containerPort: 80
  protocol: TCP
```{{copy}}

</details>

<details><summary>Solution</summary>

**Step 1 — Add the port to the deployment:**
```plain
kubectl patch deployment nodeport-deployment -n relative --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/ports","value":[{"name":"http","containerPort":80,"protocol":"TCP"}]}
]'
```{{exec}}

**Step 2 — Create the NodePort Service:**
```plain
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nodeport-service
  namespace: relative
spec:
  type: NodePort
  selector:
    app: nodeport-deployment
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30080
EOF
```{{exec}}

**Step 3 — Verify the Service and endpoints:**
```plain
kubectl get svc nodeport-service -n relative
```{{exec}}

```plain
kubectl get endpoints nodeport-service -n relative
```{{exec}}

**Step 4 — Test connectivity:**
```plain
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
curl http://$NODE_IP:30080
```{{exec}}

</details>
