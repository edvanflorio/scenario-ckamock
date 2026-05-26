#!/bin/bash
set -e

kubectl create ns mariadb --dry-run=client -o yaml | kubectl apply -f - >/dev/null

kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
  labels:
    app: mariadb
spec:
  capacity:
    storage: 250Mi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""
  hostPath:
    path: /mnt/data/mariadb
EOF

kubectl apply -f - >/dev/null <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 250Mi
  storageClassName: ""
EOF

cat <<EOF > /root/mariadb-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpass
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb
EOF

kubectl apply -f /root/mariadb-deploy.yaml >/dev/null
kubectl wait --for=condition=Available deployment/mariadb -n mariadb --timeout=60s >/dev/null 2>&1 || true

# Simula o acidente — deployment e PVC deletados, PV retido
kubectl delete deployment mariadb -n mariadb --ignore-not-found >/dev/null
kubectl delete pvc mariadb -n mariadb --ignore-not-found >/dev/null

echo "Lab setup complete!"
echo ""
echo "Simulated: Deployment and PVC deleted accidentally."
echo "The PV was retained and is available for reuse."
echo ""
kubectl get pv
