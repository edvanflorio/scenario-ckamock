#!/bin/bash

DEPLOYMENT="wordpress"
NAMESPACE="default"
PASS=true

if ! kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "FAIL: Deployment '$DEPLOYMENT' not found in namespace '$NAMESPACE'"
  exit 1
fi

if ! kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.containers[*].name}' | grep -qw "sidecar"; then
  echo "FAIL: Sidecar container 'sidecar' not found in deployment"
  PASS=false
fi

IMAGE=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].image}')
if [[ "$IMAGE" != "busybox:stable" ]]; then
  echo "FAIL: Sidecar image should be 'busybox:stable' but found '$IMAGE'"
  PASS=false
fi

CMD=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].command}')
if [[ "$CMD" != *"/bin/sh"* || "$CMD" != *"tail -f /var/log/wordpress.log"* ]]; then
  echo "FAIL: Sidecar command incorrect. Expected: '/bin/sh -c tail -f /var/log/wordpress.log'"
  PASS=false
fi

MOUNT_PATH=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.containers[?(@.name=="sidecar")].volumeMounts[*].mountPath}')
if [[ "$MOUNT_PATH" != *"/var/log"* ]]; then
  echo "FAIL: Sidecar does not have /var/log volume mounted"
  PASS=false
fi

MAIN_MOUNT=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.containers[?(@.name!="sidecar")].volumeMounts[*].mountPath}')
if [[ "$MAIN_MOUNT" != *"/var/log"* ]]; then
  echo "FAIL: Main container does not share /var/log volume with sidecar"
  PASS=false
fi

VOLUME=$(kubectl get deployment "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.volumes[*].name}')
if [[ -z "$VOLUME" ]]; then
  echo "FAIL: No volume defined in pod spec"
  PASS=false
fi

if [[ "$PASS" == true ]]; then
  echo "PASS: Sidecar container correctly configured in $DEPLOYMENT"
  exit 0
else
  echo "FAIL: Please review the errors above."
  exit 1
fi
