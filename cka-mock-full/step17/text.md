## Task: Fix the kube-apiserver After a Cluster Migration

After a cluster migration, the **controlplane kube-apiserver is not coming up**.

Before the migration, etcd was external and in HA mode. After migration, the kube-apiserver was incorrectly configured to point to etcd's **peer port 2380** instead of the **client port 2379**.

### Task

Fix the kube-apiserver so that the cluster becomes healthy again.

### Diagnose the problem

Check if kubectl works:
```plain
kubectl get nodes
```{{exec}}

Inspect the kube-apiserver logs:
```plain
journalctl -u kubelet --no-pager | grep -i "kube-apiserver\|etcd\|error\|refused" | tail -20
```{{exec}}

Check pod logs via crictl:
```plain
crictl ps -a | grep kube-apiserver
```{{exec}}

Look at the manifest:
```plain
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
```{{exec}}

---

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
