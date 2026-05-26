## List CRDs and extract documentation

<details><summary>Tip: Using kubectl explain</summary>

```plain
kubectl explain certificate.spec.subject
```{{exec}}

Use `--recursive` to see all fields:
```plain
kubectl explain certificate.spec.subject --recursive
```{{exec}}

</details>

<details><summary>Solution</summary>

**Step 1 — List cert-manager CRDs and save:**
```plain
kubectl get crd | grep cert-manager > /root/resources.yaml
```{{exec}}

```plain
cat /root/resources.yaml
```{{exec}}

**Step 2 — Extract subject field docs and save:**
```plain
kubectl explain certificate.spec.subject > /root/subject.yaml
```{{exec}}

```plain
cat /root/subject.yaml
```{{exec}}

</details>
