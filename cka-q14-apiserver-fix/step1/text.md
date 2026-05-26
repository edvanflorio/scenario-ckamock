## Fix the kube-apiserver manifest

<details><summary>Tip: Where is the misconfiguration?</summary>

The kube-apiserver static pod manifest is at:
```plain
/etc/kubernetes/manifests/kube-apiserver.yaml
```{{copy}}

Look for the `--etcd-servers` flag. The peer port is `2380`, the correct client port is `2379`.

```plain
sudo grep etcd /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — Fix the port in the manifest:**
```plain
sudo sed -i 's/:2380/:2379/g' /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

**Step 2 — Verify the fix:**
```plain
sudo grep etcd /etc/kubernetes/manifests/kube-apiserver.yaml
```{{exec}}

**Step 3 — Wait for the API server to recover (30-60 seconds):**
```plain
watch kubectl get nodes
```{{exec}}

**Step 4 — Confirm the cluster is healthy:**
```plain
kubectl get nodes
```{{exec}}

```plain
kubectl get pods -n kube-system
```{{exec}}

</details>
