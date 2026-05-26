## Congratulations!

You successfully added a sidecar container that shares a log volume with the main WordPress container.

### Key Concepts

- **Sidecar pattern**: A secondary container sharing the same Pod (and therefore the same network and optional volumes) to handle cross-cutting concerns like logging, proxying, or monitoring.
- **emptyDir volume**: An ephemeral volume created when the Pod is assigned to a node. Both containers can read/write to it. Data is lost when the Pod is removed.

### Solution Summary

```yaml
volumes:
- name: log
  emptyDir: {}

# In wordpress container:
volumeMounts:
- mountPath: /var/log
  name: log

# Sidecar container:
- name: sidecar
  image: busybox:stable
  command: ["/bin/sh", "-c", "tail -f /var/log/wordpress.log"]
  volumeMounts:
  - mountPath: /var/log
    name: log
```
