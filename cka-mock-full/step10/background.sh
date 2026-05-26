#!/bin/bash
set -e

kubectl create namespace autoscale --dry-run=client -o yaml | kubectl apply -f - >/dev/null

echo "Deploying metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml >/dev/null 2>&1

kubectl patch deployment metrics-server -n kube-system \
  --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]' >/dev/null 2>&1 || true

kubectl apply -n autoscale -f - >/dev/null <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: autoscale
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
          limits:
            cpu: 200m
EOF

kubectl expose deployment apache-deployment -n autoscale --port=80 --target-port=80 >/dev/null 2>&1 || true

echo "Lab setup complete!"
echo ""
kubectl get deployment apache-deployment -n autoscale
