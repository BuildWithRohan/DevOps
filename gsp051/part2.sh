#!/usr/bin/env bash
set -euo pipefail
ZONE="us-central1-c"
CLUSTER="jenkins-cd"
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
cd "$HOME/continuous-deployment-on-kubernetes"
kubectl create namespace production 2>/dev/null || true
find kubernetes -maxdepth 1 -type f -name '*production*.yaml' -exec kubectl apply -f {} \; 2>/dev/null || true
find kubernetes -maxdepth 1 -type f -name '*canary*.yaml' -exec kubectl apply -f {} \; 2>/dev/null || true
echo "PART 2 COMPLETE"
kubectl get pods -n production 2>/dev/null || true
