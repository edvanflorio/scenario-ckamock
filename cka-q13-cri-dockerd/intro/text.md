## Task: Set Up cri-dockerd

cri-dockerd is a CRI (Container Runtime Interface) shim that allows Docker to be used as a Kubernetes container runtime.

### Tasks

1. Install the Debian package **`~/cri-dockerd.deb`** using `dpkg`
2. **Enable and start** the `cri-docker` service using `systemctl`
3. Configure the following **kernel parameters** (persistent and active):
   - `net.bridge.bridge-nf-call-iptables = 1`
   - `net.ipv6.conf.all.forwarding = 1`
   - `net.ipv4.ip_forward = 1`
   - `net.netfilter.nf_conntrack_max = 131072`

### Inspect the environment

```plain
ls -lh ~/cri-dockerd.deb
```{{exec}}

```plain
systemctl list-units | grep docker
```{{exec}}
