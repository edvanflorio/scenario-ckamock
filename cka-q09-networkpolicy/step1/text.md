## Analyse and deploy the correct NetworkPolicy

<details><summary>Tip: Evaluating permissiveness</summary>

Compare the three policies:

- **policy-x**: `podSelector: {}` + `ingress: [{}]` — allows **ALL** ingress traffic to ALL pods → most permissive
- **policy-y**: allows frontend namespace + an additional `ipBlock: 172.16.0.0/16` — more permissive than needed
- **policy-z**: allows only traffic from pods labelled `app: frontend` in the `frontend` namespace on port 80 → **least permissive**

Check frontend pod labels to confirm they match `policy-z`'s selector:
```plain
kubectl get pods -n frontend --show-labels
```{{exec}}

</details>

<details><summary>Solution</summary>

The correct policy is **policy-z** (`network-policy-3.yaml`):

```plain
kubectl apply -f /root/network-policies/network-policy-3.yaml
```{{exec}}

**Verify:**
```plain
kubectl get networkpolicy -n backend
```{{exec}}

```plain
kubectl describe networkpolicy policy-z -n backend
```{{exec}}

</details>
