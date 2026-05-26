## Create the Service and Ingress

<details><summary>Tip: Quick Service creation</summary>

```plain
kubectl expose deployment -n echo-sound echo --name echo-service --type NodePort --port 8080 --target-port 8080
```{{exec}}

Check the assigned NodePort:
```plain
kubectl get svc echo-service -n echo-sound
```{{exec}}

</details>

<details><summary>Solution: Ingress resource</summary>

```plain
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  namespace: echo-sound
spec:
  rules:
  - host: "example.org"
    http:
      paths:
      - pathType: Prefix
        path: "/echo"
        backend:
          service:
            name: echo-service
            port:
              number: 8080
EOF
```{{exec}}

**Verify:**
```plain
kubectl get ingress echo -n echo-sound
```{{exec}}

```plain
kubectl describe ingress echo -n echo-sound
```{{exec}}

</details>
