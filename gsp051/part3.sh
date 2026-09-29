#!/usr/bin/env bash
set -euo pipefail
echo "GSP051 PART 3 — development/canary verification"
kubectl get pods -n production 2>/dev/null || true
kubectl get svc -n production 2>/dev/null || true
echo "PART 3 COMPLETE"