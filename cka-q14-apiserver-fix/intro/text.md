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
