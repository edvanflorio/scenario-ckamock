#!/bin/bash
echo "Cluster is ready."
echo ""
echo "Current cluster state:"
kubectl get nodes
echo ""
echo "Existing network resources:"
kubectl get pods -n kube-system | grep -E "canal|flannel|calico|weave|cilium" || echo "No CNI pods found in kube-system"
