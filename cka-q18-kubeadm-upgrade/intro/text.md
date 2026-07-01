## Task: Recover the Control Plane After a Broken kubeadm Upgrade

A `kubeadm upgrade` was just run on this controlplane node. Since then, the cluster has been unhealthy:

- `kubectl` commands time out or fail
- Several control plane static pods are stuck restarting
- **Not every** control plane component is affected — one of them is the actual root cause, the others are just victims of it

### Task

Find out **why** the control plane is unhealthy and **restore it** so all control plane components come back to a healthy, Running state.

### Diagnose the problem

Check if kubectl works:
```plain
kubectl get nodes
```{{exec}}

Check the state of the control plane containers directly (bypasses the broken API server):
```plain
crictl ps -a | grep -E "kube-apiserver|kube-controller-manager|kube-scheduler|etcd"
```{{exec}}

Inspect kubelet logs for the failing static pods:
```plain
journalctl -u kubelet --no-pager | tail -50
```{{exec}}

Look at the static pod manifests:
```plain
sudo ls /etc/kubernetes/manifests/
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
```{{exec}}
