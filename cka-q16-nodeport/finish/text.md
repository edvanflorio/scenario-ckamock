## Congratulations!

You successfully configured a deployment port and created a NodePort Service.

### Key Concepts

- Declaring `containerPort` in a Deployment does not expose the port — it's informational for the scheduler and tooling
- A **NodePort Service** exposes the Pod port on every node's IP at the specified `nodePort` (30000-32767 range)
- The Service `selector` must match the Pod labels to populate endpoints

### Solution Reference

```bash
# Edit deployment to add named port
kubectl patch deployment nodeport-deployment -n relative --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/ports","value":[{"name":"http","containerPort":80,"protocol":"TCP"}]}
]'

# Create NodePort service
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
```
