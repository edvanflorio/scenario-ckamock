#!/bin/bash
set -e

echo "Downloading cri-dockerd package..."
wget -q https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.debian-bullseye_amd64.deb \
  -O ~/cri-dockerd.deb

echo "Package downloaded to ~/cri-dockerd.deb"
ls -lh ~/cri-dockerd.deb

echo ""
echo "Ensuring br_netfilter kernel module is available..."
modprobe br_netfilter 2>/dev/null || true

echo ""
echo "Lab setup complete!"
