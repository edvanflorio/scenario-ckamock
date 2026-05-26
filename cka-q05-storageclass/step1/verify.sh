#!/bin/bash
set -e

SC_NAME="local-storage"

echo "Validating StorageClass configuration..."

if ! kubectl get sc "$SC_NAME" &>/dev/null; then
  echo "FAIL: StorageClass '$SC_NAME' does not exist."
  exit 1
fi

provisioner=$(kubectl get sc "$SC_NAME" -o jsonpath='{.provisioner}')
if [[ "$provisioner" != "rancher.io/local-path" ]]; then
  echo "FAIL: Provisioner is '$provisioner', expected 'rancher.io/local-path'."
  exit 1
fi
echo "PASS: Provisioner is correct: $provisioner"

mode=$(kubectl get sc "$SC_NAME" -o jsonpath='{.volumeBindingMode}')
if [[ "$mode" != "WaitForFirstConsumer" ]]; then
  echo "FAIL: VolumeBindingMode is '$mode', expected 'WaitForFirstConsumer'."
  exit 1
fi
echo "PASS: VolumeBindingMode is correct: $mode"

default_annotation=$(kubectl get sc "$SC_NAME" -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}')
if [[ "$default_annotation" != "true" ]]; then
  echo "FAIL: StorageClass '$SC_NAME' is not set as default."
  exit 1
fi
echo "PASS: '$SC_NAME' is marked as the default StorageClass."

other_defaults=$(kubectl get sc -o jsonpath='{range .items[*]}{.metadata.name}{"="}{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}{"\n"}{end}' | grep "=true" | grep -v "^$SC_NAME=" || true)

if [[ -n "$other_defaults" ]]; then
  echo "FAIL: Another StorageClass is also marked as default: $other_defaults"
  exit 1
fi
echo "PASS: '$SC_NAME' is the only default StorageClass."

echo "SUCCESS: All validations passed!"
exit 0
