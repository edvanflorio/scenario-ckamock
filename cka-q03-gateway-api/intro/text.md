## Task: Migrate Ingress to Kubernetes Gateway API

An existing web application in namespace `web-app` is exposed via an Ingress resource named **web**. You must migrate it to the new **Kubernetes Gateway API**.

### Existing configuration

```plain
kubectl describe ingress web -n web-app
```{{exec}}

```plain
kubectl get secret web-tls -n web-app
```{{exec}}

### Tasks

1. Create a **Gateway** resource named **`web-gateway`** in namespace `web-app` with:
   - Hostname: `gateway.web.k8s.local`
   - GatewayClass: `nginx-class` (already installed)
   - HTTPS listener on port 443 using the existing TLS Secret `web-tls`

2. Create an **HTTPRoute** resource named **`web-route`** in namespace `web-app` with:
   - Hostname: `gateway.web.k8s.local`
   - Route all traffic to `web-service` on port 80

> The `GatewayClass` named `nginx-class` is already installed in the cluster.
