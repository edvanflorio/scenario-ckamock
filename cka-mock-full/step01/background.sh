#!/bin/bash
echo "Cluster ready. No additional setup required."
echo "Helm is available on this node."
helm version --short 2>/dev/null || true
