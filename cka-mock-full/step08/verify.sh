#!/bin/bash
set -e

CRD_LIST_FILE="/root/resources.yaml"
SUBJECT_FILE="/root/subject.yaml"
CERT_CRD="certificates.cert-manager.io"

echo "Validating CRD documentation task..."

[ -f "$CRD_LIST_FILE" ] \
  || { echo "FAIL: $CRD_LIST_FILE does not exist"; exit 1; }
echo "PASS: CRD list file exists"

grep -q "cert-manager.io" "$CRD_LIST_FILE" \
  || { echo "FAIL: $CRD_LIST_FILE does not contain cert-manager CRDs"; exit 1; }
echo "PASS: cert-manager CRDs present in resources.yaml"

[ -f "$SUBJECT_FILE" ] \
  || { echo "FAIL: $SUBJECT_FILE does not exist"; exit 1; }
echo "PASS: subject.yaml exists"

grep -Eiq "subject" "$SUBJECT_FILE" \
  || { echo "FAIL: subject.yaml does not reference subject field"; exit 1; }

grep -Eiq "(commonName|organizations|countries|localities)" "$SUBJECT_FILE" \
  || { echo "FAIL: subject.yaml does not appear to document Certificate spec.subject"; exit 1; }
echo "PASS: subject field documentation detected"

kubectl get crd "$CERT_CRD" >/dev/null 2>&1 \
  || { echo "FAIL: Certificate CRD not found in cluster"; exit 1; }
echo "PASS: Certificate CRD exists"

echo "SUCCESS: CRD task validation PASSED"
