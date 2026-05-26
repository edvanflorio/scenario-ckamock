## Task: Expose a Deployment via Service and Ingress

An **echo** deployment is running in the `echo-sound` namespace.

### Tasks

1. Create a **Service** named **`echo-service`** in the `echo-sound` namespace:
   - Type: `NodePort`
   - Service Port: `8080`
   - Target Port: `8080`

2. Create an **Ingress** resource named **`echo`** in the `echo-sound` namespace:
   - Host: `example.org`
   - Path: `/echo`
   - Backend: `echo-service:8080`

> In a real exam, you would verify with: `curl NODEIP:NODEPORT/echo`

### Inspect the deployment

```plain
kubectl get deployment echo -n echo-sound
```{{exec}}

```plain
kubectl get pods -n echo-sound
```{{exec}}

---

## Create the Service and Ingress

<details><summary>Tip: Quick Service creation</summary>

```plain
kubectl expose deployment -n echo-sound echo --name echo-service --type NodePort --port 8080 --target-port 8080
```{{exec}}

Check the assigned NodePort:
```plain
kubectl get svc echo-service -n echo-sound
```{{exec}}

</details>

<details><summary>Solution: Ingress resource</summary>

```plain
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
```{{exec}}

**Verify:**
```plain
kubectl get ingress echo -n echo-sound
```{{exec}}

```plain
kubectl describe ingress echo -n echo-sound
```{{exec}}

</details>
