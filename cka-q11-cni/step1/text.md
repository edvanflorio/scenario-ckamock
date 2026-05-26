## Install the correct CNI

<details><summary>Tip: Why Calico?</summary>

Flannel provides basic pod-to-pod networking but **does not enforce NetworkPolicies**.
Calico provides both networking AND NetworkPolicy enforcement.

You can confirm by checking the Flannel manifest:
```plain
curl -sL https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml | grep -i network | head -5
```{{exec}}

</details>

<details><summary>Solution</summary>

Install Calico via the tigera-operator manifest:

```plain
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
```{{exec}}

Wait for the operator to deploy:
```plain
kubectl rollout status deployment tigera-operator -n tigera-operator --timeout=120s
```{{exec}}

Check the installation:
```plain
kubectl get all -n tigera-operator
```{{exec}}

```plain
kubectl get pods -n tigera-operator
```{{exec}}

</details>
