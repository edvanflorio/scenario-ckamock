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
