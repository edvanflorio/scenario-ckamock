#!/bin/bash

# Validator script for Question-1: Install Argo CD via Helm without reinstalling existing CRDs

# Check 1: Verify Argo CD Helm repository is added
echo "Checking if argocd Helm repository is added..."
helm_repo_list=$(helm repo list 2>/dev/null)
if echo "${helm_repo_list}" | grep -q "argocd.*https://argoproj.github.io/argo-helm"; then
    echo "  [PASS] Argo CD Helm repository 'argocd' is added."
    repo_added=true
else
    echo "  [FAIL] Argo CD Helm repository 'argocd' is NOT added."
    repo_added=false
fi

# Check 2: Verify the release is actually deployed
echo "Checking if Argo CD release is deployed in namespace 'argocd'..."
release_line=$(helm list -n argocd 2>/dev/null | grep -w "argocd")
if echo "${release_line}" | grep -q "deployed"; then
    echo "  [PASS] Helm release 'argocd' is deployed in namespace 'argocd'."
    release_deployed=true
else
    echo "  [FAIL] Helm release 'argocd' is NOT deployed in namespace 'argocd'."
    release_deployed=false
fi

# Check 3: Verify chart version
echo "Checking chart version..."
if echo "${release_line}" | grep -q "argo-cd-7.7.3"; then
    echo "  [PASS] Chart version 7.7.3 is used."
    version_ok=true
else
    echo "  [FAIL] Chart version 7.7.3 was NOT used."
    version_ok=false
fi

# Check 4: Verify the release itself did not (re)install CRDs
echo "Checking that CRDs were NOT reinstalled by this release..."
if ${release_deployed}; then
    crd_count=$(helm get manifest argocd -n argocd 2>/dev/null | grep -c "kind: CustomResourceDefinition")
    if [ "${crd_count}" -eq 0 ]; then
        echo "  [PASS] Release manifest contains no CustomResourceDefinitions (crds.install=false)."
        no_crds=true
    else
        echo "  [FAIL] Release manifest contains CustomResourceDefinitions — crds.install should be false."
        no_crds=false
    fi
else
    echo "  [SKIP] Skipping CRD manifest check because the release is not deployed."
    no_crds=false
fi

# Check 5: Verify the pre-existing CRDs are still present and untouched
echo "Checking that pre-existing Argo CD CRDs are still present in the cluster..."
crd_total=$(kubectl get crd 2>/dev/null | grep -c "argoproj.io")
if [ "${crd_total}" -ge 3 ]; then
    echo "  [PASS] Pre-installed Argo CD CRDs are present (${crd_total} found)."
    crds_present=true
else
    echo "  [FAIL] Argo CD CRDs are missing from the cluster."
    crds_present=false
fi

# Check 6: Verify core Argo CD workloads exist
echo "Checking core Argo CD workloads in namespace 'argocd'..."
if kubectl get deploy -n argocd 2>/dev/null | grep -q "argocd-server"; then
    echo "  [PASS] Deployment 'argocd-server' found."
    workloads_ok=true
else
    echo "  [FAIL] Deployment 'argocd-server' not found."
    workloads_ok=false
fi

echo -e "\n--- Overall Result ---"
if ${repo_added} && ${release_deployed} && ${version_ok} && ${no_crds} && ${crds_present} && ${workloads_ok}; then
    echo "  [SUCCESS] All checks passed for Question-1!"
    exit 0
else
    echo "  [FAILURE] One or more checks failed for Question-1."
    exit 1
fi
