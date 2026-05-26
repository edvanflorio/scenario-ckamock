#!/bin/bash
set -e

echo "Creating WordPress deployment with 3 replicas and init container..."

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox
        command: ["sh", "-c", "echo 'Preparing environment...' && sleep 2"]
      containers:
      - name: wordpress
        image: wordpress:6.2-apache
        ports:
        - containerPort: 80
EOF

echo "Lab setup complete. Waiting for pods to start..."
kubectl rollout status deployment wordpress --timeout=120s || true
