#!/bin/bash
set -e

kubectl create ns echo-sound --dry-run=client -o yaml | kubectl apply -f - >/dev/null

cat <<EOF | kubectl -n echo-sound apply -f - >/dev/null
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: gcr.io/google_containers/echoserver:1.10
        ports:
        - containerPort: 8080
EOF

echo "Lab setup complete!"
echo ""
echo "Deployment 'echo' in namespace 'echo-sound':"
kubectl get deployment echo -n echo-sound
