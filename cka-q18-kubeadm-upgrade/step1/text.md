## Diagnose and fix the control plane

<details><summary>Tip: Where to look</summary>

`kube-apiserver`'s logs (via `crictl` or `/var/log/pods/`) will show a TLS or **"no such file or directory"** error for one of its `--etcd-*` flags.

```plain
sudo grep etcd /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

Check whether the files referenced by `--etcd-certfile` and `--etcd-keyfile` actually exist:
```plain
sudo ls -la /etc/kubernetes/pki/apiserver-etcd-client*
```{{exec}}

`kube-controller-manager` and `kube-scheduler` both wait on the API server during their startup — that's why they show unhealthy too, even though **their own manifests were never touched**. `etcd` itself is unaffected, since the broken files belong to kube-apiserver's etcd **client** cert, not etcd's own serving cert.

</details>

<details><summary>Solution</summary>

**Step 1 — Confirm kube-apiserver is crashing:**
```plain
crictl ps -a | grep kube-apiserver
```{{exec}}

**Step 2 — Check its logs for the exact error:**
```plain
crictl logs $(crictl ps -a --name kube-apiserver -q | head -1) 2>&1 | tail -20
```{{exec}}

**Step 3 — Find the etcd client cert/key paths in the manifest:**
```plain
sudo grep etcd /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

**Step 4 — Confirm the referenced files are missing, and find where they went:**
```plain
sudo ls -la /etc/kubernetes/pki/ | grep apiserver-etcd-client
```{{exec}}

**Step 5 — Restore the cert/key to the path the manifest expects:**
```plain
sudo mv /etc/kubernetes/pki/apiserver-etcd-client.crt.upgraded /etc/kubernetes/pki/apiserver-etcd-client.crt
sudo mv /etc/kubernetes/pki/apiserver-etcd-client.key.upgraded /etc/kubernetes/pki/apiserver-etcd-client.key
```{{exec}}

**Step 6 — Wait for the control plane to recover (30-60 seconds):**
```plain
watch kubectl get nodes
```{{exec}}

**Step 7 — Confirm every control plane component is healthy again:**
```plain
kubectl get pods -n kube-system
```{{exec}}

</details>
