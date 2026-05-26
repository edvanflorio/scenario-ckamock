## Congratulations!

You successfully applied a taint and scheduled a Pod with the matching toleration.

### Key Concepts

- **Taint**: Applied to a node — repels Pods that don't tolerate it
- **Toleration**: Applied to a Pod — allows scheduling on nodes with the matching taint
- **NoSchedule**: New Pods without toleration will not be scheduled (existing Pods stay)
- **NoExecute**: Evicts existing Pods without toleration AND prevents new ones

### Taint Effects

| Effect | Behavior |
|--------|----------|
| `NoSchedule` | New Pods without toleration are not scheduled |
| `PreferNoSchedule` | Soft version — scheduler avoids the node if possible |
| `NoExecute` | Evicts existing Pods and prevents new scheduling |

### Solution Reference

```bash
# Add taint
kubectl taint nodes node01 PERMISSION=granted:NoSchedule

# Pod with matching toleration
tolerations:
- key: "PERMISSION"
  operator: "Equal"
  value: "granted"
  effect: "NoSchedule"
```
