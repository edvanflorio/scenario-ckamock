## Congratulations!

You successfully diagnosed and fixed a kube-apiserver misconfiguration.

### Key Concepts

- **etcd ports**:
  - **2379**: client port (kube-apiserver communicates here)
  - **2380**: peer port (etcd cluster members communicate here — NOT for kube-apiserver)
- **Static pod manifests** in `/etc/kubernetes/manifests/` are watched by the kubelet — editing them triggers an automatic pod restart
- Diagnosing API server issues requires using `crictl`, `journalctl`, or pod log files at `/var/log/pods/`

### Debugging Approach for CKA

```bash
# 1. Check if API server responds
kubectl get nodes

# 2. Look at kubelet logs
journalctl -u kubelet --no-pager | grep error | tail -20

# 3. Check the static pod logs
ls /var/log/pods/kube-system_kube-apiserver-*/
cat /var/log/pods/kube-system_kube-apiserver-*/kube-apiserver/0.log | tail -20

# 4. Inspect the manifest
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd

# 5. Fix and wait
sudo sed -i 's/:2380/:2379/g' /etc/kubernetes/manifests/kube-apiserver.yaml
```
