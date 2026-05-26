## Congratulations!

You correctly identified and applied the least permissive NetworkPolicy.

### Policy Analysis

| Policy | Issue | Verdict |
|--------|-------|---------|
| policy-x | Allows ALL ingress to ALL pods (no selector, no restriction) | Too permissive |
| policy-y | Adds extra `ipBlock: 172.16.0.0/16` not required by the task | Too permissive |
| policy-z | Only allows `app: frontend` pods from the `frontend` namespace on port 80 | **Correct** |

### Key Concepts

- **NetworkPolicy** `podSelector: {}` with empty `ingress: [{}]` means "allow all traffic to all pods" — effectively no restriction
- Using **both** `namespaceSelector` AND `podSelector` in the same `from` entry applies both conditions (AND logic)
- **Least privilege** is a core security principle — only allow exactly what is needed
