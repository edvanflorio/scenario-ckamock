## Task: Configure Nginx to Support Only TLSv1.3

There is a running nginx deployment in the `nginx-static` namespace. The nginx ConfigMap currently allows both TLSv1.2 and TLSv1.3.

### Tasks

1. Edit the **ConfigMap** `nginx-config` in the `nginx-static` namespace to **only support TLSv1.3** (remove TLSv1.2)

2. Add the **ClusterIP of the `nginx-static` service** to `/etc/hosts` with the hostname `ckaquestion.k8s.local`

3. Restart the deployment so the new configuration takes effect

4. **Verify** the configuration:
   - `curl -vk --tls-max 1.2 https://ckaquestion.k8s.local` → should **fail**
   - `curl -vk --tlsv1.3 https://ckaquestion.k8s.local` → should **succeed**

### Inspect the environment

```plain
kubectl get svc -n nginx-static
```{{exec}}

```plain
kubectl get cm nginx-config -n nginx-static -o yaml
```{{exec}}
