#!/bin/bash
echo "Two-node cluster is ready."
echo ""
echo "Nodes:"
kubectl get nodes
echo ""
echo "Current taints on node01:"
kubectl describe node node01 | grep -A3 "Taints:"
