## Congratulations!

You successfully diagnosed and recovered a control plane broken by a bad kubeadm upgrade.

### Key Concepts

- **kube-apiserver talks to etcd as a client**, using its own client cert/key (`--etcd-certfile` / `--etcd-keyfile`) — separate from etcd's own serving certs. If an upgrade renames or moves those files without updating the manifest, kube-apiserver crashes on startup.
- **kube-controller-manager and kube-scheduler both depend on the API server** during startup (leader election, discovery). When the API server is down, they show unhealthy too — even though nothing in *their* manifests changed. This is why "several, but not all" components break from a single root cause.
- **etcd, kubelet, and kube-proxy are unaffected** in this scenario: etcd's own serving certs were untouched, and already-running Pods don't need the API server to keep running.
- Static pod manifests in `/etc/kubernetes/manifests/` are watched by the kubelet — fixing the file paths (or the manifest) triggers an automatic restart.

### Debugging Approach for CKA

```bash
# 1. Check if API server responds
kubectl get nodes

# 2. Bypass the broken API server and check containers directly
crictl ps -a | grep -E "kube-apiserver|kube-controller-manager|kube-scheduler|etcd"

# 3. Check the failing container's logs
crictl logs <container-id>

# 4. Inspect the manifest for the broken flag/path
sudo grep etcd /etc/kubernetes/manifests/kube-apiserver.yaml

# 5. Confirm which referenced files are missing
sudo ls -la /etc/kubernetes/pki/ | grep apiserver-etcd-client

# 6. Restore the correct file paths and wait for recovery
sudo mv /etc/kubernetes/pki/apiserver-etcd-client.crt.upgraded /etc/kubernetes/pki/apiserver-etcd-client.crt
sudo mv /etc/kubernetes/pki/apiserver-etcd-client.key.upgraded /etc/kubernetes/pki/apiserver-etcd-client.key
```
