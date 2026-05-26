#!/bin/bash
set -e

DEPLOYMENT="busybox-logger"
NAMESPACE="priority"
PC_NAME="high-priority"

echo "Validating PriorityClass and Deployment setup..."

user_pcs=$(kubectl get priorityclass -o jsonpath='{range .items[*]}{.metadata.name}{"="}{.value}{"\n"}{end}' | grep -vE 'system-cluster-critical|system-node-critical' || true)

if [[ -z "$user_pcs" ]]; then
  echo "FAIL: No user-defined PriorityClasses found in cluster."
  exit 1
fi

highest_value=$(echo "$user_pcs" | awk -F= '{print $2}' | sort -nr | head -1)

if ! kubectl get priorityclass "$PC_NAME" &>/dev/null; then
  echo "FAIL: PriorityClass '$PC_NAME' not found."
  exit 1
fi

pc_value=$(kubectl get priorityclass "$PC_NAME" -o jsonpath='{.value}')
expected_value=$((highest_value - 1))

if [[ "$pc_value" -ne "$expected_value" ]]; then
  echo "FAIL: '$PC_NAME' has value $pc_value, expected $expected_value (one less than highest: $highest_value)."
  exit 1
fi
echo "PASS: '$PC_NAME' value is correct: $pc_value"

if ! kubectl get deploy "$DEPLOYMENT" -n "$NAMESPACE" &>/dev/null; then
  echo "FAIL: Deployment '$DEPLOYMENT' not found in namespace '$NAMESPACE'."
  exit 1
fi

dep_pc=$(kubectl get deploy "$DEPLOYMENT" -n "$NAMESPACE" -o jsonpath='{.spec.template.spec.priorityClassName}')

if [[ "$dep_pc" != "$PC_NAME" ]]; then
  echo "FAIL: Deployment '$DEPLOYMENT' uses '$dep_pc', expected '$PC_NAME'."
  exit 1
fi
echo "PASS: Deployment '$DEPLOYMENT' uses the correct PriorityClass: $dep_pc"

echo "SUCCESS: All validations passed!"
exit 0
