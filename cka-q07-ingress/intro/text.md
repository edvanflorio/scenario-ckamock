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
