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

---

## Create the Gateway and HTTPRoute

<details><summary>Tip: Gateway API resource reference</summary>

**Gateway** (`gateway.networking.k8s.io/v1`):
```plain
kubectl api-resources | grep gateway
```{{exec}}

```plain
kubectl explain gateway.spec
```{{exec}}

</details>

<details><summary>Solution: Gateway resource</summary>

```plain
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-app
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls
EOF
```{{exec}}

</details>

<details><summary>Solution: HTTPRoute resource</summary>

```plain
cat <<EOF | kubectl apply -f -
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - "gateway.web.k8s.local"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
EOF
```{{exec}}

**Verify:**
```plain
kubectl get gateway,httproute -n web-app
```{{exec}}

</details>
