## Congratulations!

You correctly identified and installed Calico as the CNI that supports NetworkPolicy enforcement.

### Key Decision

| Requirement | Flannel | Calico |
|-------------|---------|--------|
| Pod-to-pod communication | ✅ | ✅ |
| NetworkPolicy enforcement | ❌ | ✅ |
| Manifest-based install | ✅ | ✅ |

**Calico** is the only option that meets all three requirements.

### Solution Reference

```bash
# Install Calico via tigera-operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

# Verify
kubectl get all -n tigera-operator
```

### CKA Exam Tips
- Calico also has a `custom-resources.yaml` that may need to be applied after the operator
- Always check the installed resources with `kubectl get all -n tigera-operator`
