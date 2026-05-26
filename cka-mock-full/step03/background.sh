#!/bin/bash
set -e

echo "Installing Gateway API CRDs..."
kubectl apply -k "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" >/dev/null 2>&1 || true

kubectl create ns web-app --dry-run=client -o yaml | kubectl apply -f - >/dev/null

cat <<EOF | kubectl apply -n web-app -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - name: http
    port: 80
    targetPort: 80
EOF

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=gateway.web.k8s.local/O=web" >/dev/null 2>&1

kubectl create secret tls web-tls --cert=/tmp/tls.crt --key=/tmp/tls.key -n web-app >/dev/null 2>&1 || true
rm -f /tmp/tls.crt /tmp/tls.key

cat <<EOF | kubectl apply -n web-app -f - >/dev/null
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
    - gateway.web.k8s.local
    secretName: web-tls
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

cat <<EOF | kubectl apply -f - >/dev/null
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: example.net/nginx-gateway-controller
EOF

echo "Lab setup complete!"
echo ""
kubectl get ingress,secret -n web-app
echo ""
echo "GatewayClass 'nginx-class' is installed and ready."
