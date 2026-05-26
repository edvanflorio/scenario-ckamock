## Congratulations!

You successfully explored Custom Resource Definitions using `kubectl`.

### Key Concepts

- **CRDs** (CustomResourceDefinitions) extend the Kubernetes API with custom resource types
- `kubectl get crd` lists all CRDs installed in the cluster
- `kubectl explain <resource>.<field>` shows inline API documentation — works for CRDs too
- The `>` redirect saves command output to a file

### Solution Reference

```bash
# List cert-manager CRDs
kubectl get crd | grep cert-manager > /root/resources.yaml

# Extract subject field documentation
kubectl explain certificate.spec.subject > /root/subject.yaml
```
