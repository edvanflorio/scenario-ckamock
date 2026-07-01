## Congratulations!

You successfully configured nginx to allow TLSv1.2 alongside TLSv1.3.

### Key Concepts

- **`ssl_protocols`** in nginx controls which TLS versions are accepted
- After editing a ConfigMap, you must **restart the deployment** for the change to be persisted — Pods don't automatically pick up ConfigMap changes unless they use `subPath` with manual restart
- Adding an entry to `/etc/hosts` allows DNS resolution for internal service IPs without an external DNS

### Solution Reference

```bash
# Edit ConfigMap (change TLSv1.3 → TLSv1.2 TLSv1.3)
kubectl edit cm nginx-config -n nginx-static

# Add service IP to /etc/hosts
SERVICE_IP=$(kubectl get svc nginx-static -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SERVICE_IP ckaquestion.k8s.local" >> /etc/hosts

# Restart deployment so the change is persisted
kubectl rollout restart deployment nginx-static -n nginx-static

# Test
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local   # should succeed
curl -vk --tlsv1.3 https://ckaquestion.k8s.local        # should succeed
```
