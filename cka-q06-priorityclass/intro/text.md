## Task: PriorityClass and Deployment Patch

You're working with a Kubernetes cluster that already has at least one user-defined **PriorityClass**.

### Tasks

1. Inspect the existing PriorityClasses and find the **highest user-defined value**

2. Create a new **PriorityClass** named **`high-priority`** with a value **exactly one less** than the highest existing user-defined priority class

3. **Patch** the existing deployment **`busybox-logger`** in the **`priority`** namespace to use the newly created `high-priority` class

### Inspect existing PriorityClasses

```plain
kubectl get priorityclass
```{{exec}}
