#!/bin/bash
set -e

PACKAGE="cri-dockerd"
SERVICE="cri-docker"

echo "Validating cri-dockerd setup..."

dpkg -l | grep -qw "$PACKAGE" \
  || { echo "FAIL: Package $PACKAGE is not installed"; exit 1; }
echo "PASS: cri-dockerd package installed"

systemctl list-unit-files | grep -qw "$SERVICE.service" \
  || { echo "FAIL: Service $SERVICE.service not found"; exit 1; }
echo "PASS: cri-docker service exists"

systemctl is-enabled "$SERVICE" >/dev/null 2>&1 \
  || { echo "FAIL: cri-docker service is not enabled"; exit 1; }
echo "PASS: cri-docker service enabled"

systemctl is-active "$SERVICE" >/dev/null 2>&1 \
  || { echo "FAIL: cri-docker service is not running"; exit 1; }
echo "PASS: cri-docker service running"

lsmod | grep -qw br_netfilter \
  || { echo "FAIL: br_netfilter kernel module not loaded"; exit 1; }
echo "PASS: br_netfilter module loaded"

declare -A SYSCTLS
SYSCTLS["net.bridge.bridge-nf-call-iptables"]="1"
SYSCTLS["net.ipv6.conf.all.forwarding"]="1"
SYSCTLS["net.ipv4.ip_forward"]="1"
SYSCTLS["net.netfilter.nf_conntrack_max"]="131072"

for key in "${!SYSCTLS[@]}"; do
  value=$(sysctl -n "$key" 2>/dev/null || echo "")
  expected="${SYSCTLS[$key]}"
  [ "$value" = "$expected" ] \
    || { echo "FAIL: $key=$value (expected $expected)"; exit 1; }
  echo "PASS: $key correctly set to $expected"
done

echo "SUCCESS: cri-dockerd setup validated successfully"
