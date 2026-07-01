#!/bin/bash
set -e

URL="https://ckaquestion.k8s.local"

echo "Starting TLS validation..."

echo "Checking /etc/hosts entry..."
grep -q "ckaquestion.k8s.local" /etc/hosts \
  || { echo "FAIL: ckaquestion.k8s.local not found in /etc/hosts"; exit 1; }
echo "PASS: /etc/hosts entry present"

echo "Checking ConfigMap allows TLSv1.2..."
kubectl get cm nginx-config -n nginx-static -o jsonpath='{.data.nginx\.conf}' | grep -q "ssl_protocols.*TLSv1\.2" \
  || { echo "FAIL: ConfigMap does not allow TLSv1.2"; exit 1; }
echo "PASS: ConfigMap allows TLSv1.2"

echo "Checking TLS 1.2 (should succeed)..."
if curl -sk --tls-max 1.2 "$URL" >/dev/null 2>&1; then
  echo "PASS: TLS 1.2 connection succeeded"
else
  echo "FAIL: TLS 1.2 connection failed (should be allowed)"
  exit 1
fi

echo "Checking TLS 1.3 (should still succeed)..."
if curl -sk --tlsv1.3 "$URL" >/dev/null 2>&1; then
  echo "PASS: TLS 1.3 connection succeeded"
else
  echo "FAIL: TLS 1.3 connection failed"
  exit 1
fi

echo ""
echo "SUCCESS: TLS configuration is valid"
