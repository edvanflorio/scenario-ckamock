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

---

## Install and configure cri-dockerd

<details><summary>Tip: Installing the package</summary>

Use `dpkg -i` to install a local `.deb` package:
```plain
dpkg -i ~/cri-dockerd.deb
```{{exec}}

After installing, enable and start the service:
```plain
systemctl enable --now cri-docker.service
```{{exec}}

```plain
systemctl status cri-docker.service
```{{exec}}

</details>

<details><summary>Tip: Loading br_netfilter (required for bridge sysctl)</summary>

The `net.bridge.bridge-nf-call-iptables` sysctl requires the `br_netfilter` module:
```plain
modprobe br_netfilter
```{{exec}}

```plain
lsmod | grep br_netfilter
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — Install the package:**
```plain
dpkg -i ~/cri-dockerd.deb
```{{exec}}

**Step 2 — Enable and start the service:**
```plain
systemctl enable --now cri-docker.service
```{{exec}}

**Step 3 — Load br_netfilter and apply sysctl settings:**
```plain
modprobe br_netfilter
```{{exec}}

```plain
sysctl -w net.bridge.bridge-nf-call-iptables=1
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.netfilter.nf_conntrack_max=131072
```{{exec}}

**Step 4 — Make settings persistent:**
```plain
cat <<EOF > /etc/sysctl.d/99-cri-dockerd.conf
net.bridge.bridge-nf-call-iptables=1
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
net.netfilter.nf_conntrack_max=131072
EOF
```{{exec}}

```plain
sysctl --system
```{{exec}}

**Step 5 — Verify:**
```plain
systemctl is-active cri-docker
```{{exec}}

```plain
sysctl net.bridge.bridge-nf-call-iptables net.ipv4.ip_forward net.netfilter.nf_conntrack_max
```{{exec}}

</details>
