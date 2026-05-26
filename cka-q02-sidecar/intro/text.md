## Task: Add a Sidecar Container

An existing **wordpress** deployment is running in the `default` namespace.

### Tasks

1. Edit the `wordpress` deployment to add a **sidecar container** with:
   - Name: `sidecar`
   - Image: `busybox:stable`
   - Command: `/bin/sh -c "tail -f /var/log/wordpress.log"`
2. Mount a shared **emptyDir volume** at `/var/log` on **both** the main container and the sidecar container
3. The log file `/var/log/wordpress.log` must be accessible to the sidecar via this shared volume

### Current state

```plain
kubectl get deployment wordpress
```{{exec}}

```plain
kubectl describe deployment wordpress
```{{exec}}
