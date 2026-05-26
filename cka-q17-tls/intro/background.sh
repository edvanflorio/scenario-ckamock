#!/bin/bash
set -e

kubectl create namespace nginx-static --dry-run=client -o yaml | kubectl apply -f - >/dev/null

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=ckaquestion.k8s.local" >/dev/null 2>&1

kubectl -n nginx-static create secret tls nginx-tls --cert=/tmp/tls.crt --key=/tmp/tls.key >/dev/null 2>&1 || true
rm -f /tmp/tls.crt /tmp/tls.key

cat <<EOF | kubectl -n nginx-static apply -f - >/dev/null
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {}
    http {
      server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/tls/tls.crt;
        ssl_certificate_key /etc/nginx/tls/tls.key;
        ssl_protocols TLSv1.2 TLSv1.3;
        location / {
          return 200 "Hello TLS\n";
        }
      }
    }
EOF

cat <<EOF | kubectl -n nginx-static apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls
          mountPath: /etc/nginx/tls
      volumes:
      - name: config
        configMap:
          name: nginx-config
      - name: tls
        secret:
          secretName: nginx-tls
EOF

kubectl -n nginx-static expose deployment nginx-static --port=443 --target-port=443 --name=nginx-static >/dev/null 2>&1 || true

echo "Lab setup complete!"
echo ""
echo "Service:"
kubectl get svc -n nginx-static
echo ""
echo "Current ConfigMap:"
kubectl get cm nginx-config -n nginx-static -o jsonpath='{.data.nginx\.conf}' | grep ssl_protocols
