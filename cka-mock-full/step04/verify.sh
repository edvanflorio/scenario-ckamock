#!/bin/bash
set -e

DEPLOYMENT="wordpress"
EXPECTED_REPLICAS=3

echo "Validating WordPress resource configuration..."

if ! kubectl get deployment "$DEPLOYMENT" &>/dev/null; then
  echo "FAIL: Deployment '$DEPLOYMENT' does not exist."
  exit 1
fi

ready=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.status.readyReplicas}')
if [[ "$ready" != "$EXPECTED_REPLICAS" ]]; then
  echo "FAIL: Expected $EXPECTED_REPLICAS ready replicas, found: ${ready:-0}."
  exit 1
fi
echo "PASS: Deployment has $EXPECTED_REPLICAS ready replicas."

not_running=$(kubectl get pods -l app=wordpress --field-selector=status.phase!=Running --no-headers 2>/dev/null | wc -l)
if [[ "$not_running" -gt 0 ]]; then
  echo "FAIL: Some wordpress pods are not in Running state."
  kubectl get pods -l app=wordpress
  exit 1
fi
echo "PASS: All wordpress pods are Running."

cpu_req=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')
mem_req=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')
cpu_lim=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')
mem_lim=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')

if [[ -z "$cpu_req" || -z "$mem_req" || -z "$cpu_lim" || -z "$mem_lim" ]]; then
  echo "FAIL: Main container is missing resource requests or limits."
  exit 1
fi
echo "PASS: Main container resources — requests: cpu=$cpu_req, memory=$mem_req | limits: cpu=$cpu_lim, memory=$mem_lim"

init_cpu_req=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}')
init_mem_req=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}')
init_cpu_lim=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.cpu}')
init_mem_lim=$(kubectl get deployment "$DEPLOYMENT" -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.memory}')

if [[ -z "$init_cpu_req" || -z "$init_mem_req" || -z "$init_cpu_lim" || -z "$init_mem_lim" ]]; then
  echo "FAIL: Init container is missing resource requests or limits."
  exit 1
fi
echo "PASS: Init container resources — requests: cpu=$init_cpu_req, memory=$init_mem_req | limits: cpu=$init_cpu_lim, memory=$init_mem_lim"

if [[ "$cpu_req" != "$init_cpu_req" || "$mem_req" != "$init_mem_req" || \
      "$cpu_lim" != "$init_cpu_lim" || "$mem_lim" != "$init_mem_lim" ]]; then
  echo "FAIL: Init container resources do not match main container resources."
  echo "   Main:  requests cpu=$cpu_req mem=$mem_req | limits cpu=$cpu_lim mem=$mem_lim"
  echo "   Init:  requests cpu=$init_cpu_req mem=$init_mem_req | limits cpu=$init_cpu_lim mem=$init_mem_lim"
  exit 1
fi
echo "PASS: Init container and main container have identical resource requests and limits."

echo "SUCCESS: All validations passed!"
exit 0
