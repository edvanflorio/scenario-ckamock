## Congratulations!

You successfully migrated an Ingress resource to the Kubernetes Gateway API.

### Key Concepts

- **Gateway API** is the successor to Ingress — more expressive, supports multi-tenancy, and handles L4/L7 routing
- A **GatewayClass** defines the controller (like an IngressClass)
- A **Gateway** defines the listening configuration (ports, protocols, TLS)
- An **HTTPRoute** defines the routing rules (hostnames, paths, backends)

### Quick reference

```yaml
# Gateway
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
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

# HTTPRoute
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - "gateway.web.k8s.local"
  rules:
  - backendRefs:
    - name: web-service
      port: 80
```
