#!/usr/bin/env bash
set -euo pipefail
ZONE="$(gcloud config get-value compute/zone)"
gcloud container clusters get-credentials jenkins-cd --zone "$ZONE"
echo "===== GSP051 FINAL VERIFICATION ====="
kubectl get pods
kubectl get svc
kubectl get deployments
echo "===== PRODUCTION ====="
kubectl get pods -l app=gceme
kubectl get svc -l app=gceme
echo "PART 4 COMPLETE"
