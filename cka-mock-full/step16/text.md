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

---

## Update TLS configuration and verify

<details><summary>Tip: Editing the ConfigMap</summary>

```plain
kubectl edit cm nginx-config -n nginx-static
```{{exec}}

Change the line:
```plain
ssl_protocols TLSv1.2 TLSv1.3;
```{{copy}}

to:
```plain
ssl_protocols TLSv1.3;
```{{copy}}

Save and exit. Then restart the deployment to load the new config.

</details>

<details><summary>Solution</summary>

**Step 1 — Edit the ConfigMap to remove TLSv1.2:**
```plain
kubectl edit cm nginx-config -n nginx-static
```{{exec}}

Change `ssl_protocols TLSv1.2 TLSv1.3;` to `ssl_protocols TLSv1.3;`

**Step 2 — Get the Service IP:**
```plain
kubectl get svc nginx-static -n nginx-static -o jsonpath='{.spec.clusterIP}'
```{{exec}}

**Step 3 — Add to /etc/hosts:**
```plain
SERVICE_IP=$(kubectl get svc nginx-static -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SERVICE_IP ckaquestion.k8s.local" >> /etc/hosts
cat /etc/hosts | tail -3
```{{exec}}

**Step 4 — Restart the deployment:**
```plain
kubectl rollout restart deployment nginx-static -n nginx-static
```{{exec}}

```plain
kubectl rollout status deployment nginx-static -n nginx-static
```{{exec}}

**Step 5 — Test:**
```plain
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local
```{{exec}}

```plain
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```{{exec}}

</details>
