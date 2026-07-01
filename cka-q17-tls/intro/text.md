## Task: Allow TLSv1.2 on Nginx

There is a running nginx deployment in the `nginx-static` namespace. The nginx ConfigMap currently only supports TLSv1.3.

### Tasks

1. Edit the **ConfigMap** `nginx-config` in the `nginx-static` namespace to **also allow TLSv1.2** (keep TLSv1.3 enabled too)

2. Add the **ClusterIP of the `nginx-static` service** to `/etc/hosts` with the hostname `ckaquestion.k8s.local`

3. Restart the deployment so the new configuration is **persisted** and picked up by the running Pods

4. **Verify** the configuration:
   - `curl -vk --tls-max 1.2 https://ckaquestion.k8s.local` → should **succeed**
   - `curl -vk --tlsv1.3 https://ckaquestion.k8s.local` → should **succeed**

### Inspect the environment

```plain
kubectl get svc -n nginx-static
```{{exec}}

```plain
kubectl get cm nginx-config -n nginx-static -o yaml
```{{exec}}
