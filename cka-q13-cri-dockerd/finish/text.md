## Congratulations!

You successfully installed cri-dockerd and configured the required kernel parameters.

### Key Concepts

- **cri-dockerd**: A shim that implements the Kubernetes CRI interface, allowing Docker Engine to be used as the container runtime
- **br_netfilter**: Required kernel module for bridge-based network filtering — must be loaded before setting bridge sysctl values
- **`sysctl -w`** applies settings immediately; persisting them requires a file in `/etc/sysctl.d/`

### Solution Reference

```bash
# Install
dpkg -i ~/cri-dockerd.deb

# Enable and start service
systemctl enable --now cri-docker.service

# Load kernel module and set sysctls
modprobe br_netfilter
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.netfilter.nf_conntrack_max=131072

# Make persistent
cat <<EOF > /etc/sysctl.d/99-cri-dockerd.conf
net.bridge.bridge-nf-call-iptables=1
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=131072
EOF
sysctl --system
```
