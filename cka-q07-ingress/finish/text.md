## Congratulations!

You successfully exposed a deployment via a NodePort Service and configured an Ingress resource.

### Key Concepts

- **NodePort** exposes the service on a static port on each node's IP — reachable as `NodeIP:NodePort`
- **Ingress** provides HTTP/HTTPS routing to services based on hostnames and paths
- The Ingress controller (not the Ingress resource itself) handles the actual traffic routing

### Solution Reference

```bash
# Create the NodePort Service
kubectl expose deployment -n echo-sound echo \
  --name echo-service --type NodePort --port 8080 --target-port 8080

# Create the Ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: "example.org"
    http:
      paths:
      - pathType: Prefix
        path: "/echo"
        backend:
          service:
            name: echo-service
            port:
              number: 8080
EOF
```
