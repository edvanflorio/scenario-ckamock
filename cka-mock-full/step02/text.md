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

---

## Add the sidecar container

Edit the `wordpress` deployment to add the sidecar and shared volume, then click **Check**.

<details><summary>Tip: Editing a deployment</summary>

Open the deployment spec in your editor:

```plain
kubectl edit deployment wordpress
```{{exec}}

Look for `spec.template.spec` and add:
- A new container named `sidecar`
- A `volumes` section with an `emptyDir` volume
- `volumeMounts` on both containers pointing to `/var/log`

</details>

<details><summary>Solution</summary>

The diff to apply in `kubectl edit deployment wordpress`:

```plain
kubectl patch deployment wordpress --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/volumes","value":[{"name":"log","emptyDir":{}}]},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts","value":[{"name":"log","mountPath":"/var/log"}]},
  {"op":"add","path":"/spec/template/spec/containers/-","value":{"name":"sidecar","image":"busybox:stable","command":["/bin/sh","-c","tail -f /var/log/wordpress.log"],"volumeMounts":[{"name":"log","mountPath":"/var/log"}]}}
]'
```{{exec}}

Verify both containers are running:
```plain
kubectl get pods -l app=wordpress
```{{exec}}

```plain
kubectl describe deployment wordpress | grep -A5 "Containers:"
```{{exec}}

</details>
