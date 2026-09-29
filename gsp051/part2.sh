#!/usr/bin/env bash
set -euo pipefail

echo "===== GSP051 PART 2: Jenkins/Application Setup ====="

ZONE="us-central1-c"
CLUSTER="jenkins-cd"

gcloud config set compute/zone "$ZONE" >/dev/null
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"

cd "$HOME/continuous-deployment-on-kubernetes"

kubectl create namespace production 2>/dev/null || true

if [ -f "kubernetes/production.yaml" ]; then
  kubectl apply -f kubernetes/production.yaml
elif [ -f "kubernetes/production-app.yaml" ]; then
  kubectl apply -f kubernetes/production-app.yaml
fi

if [ -f "kubernetes/canary.yaml" ]; then
  kubectl apply -f kubernetes/canary.yaml
elif [ -f "kubernetes/canary-app.yaml" ]; then
  kubectl apply -f kubernetes/canary-app.yaml
fi

kubectl get pods -n production 2>/dev/null || true
kubectl get svc -n production 2>/dev/null || true

echo
echo "Jenkins admin secret (when available):"
kubectl get secret cd-jenkins -n jenkins -o jsonpath='{.data.jenkins-admin-password}' 2>/dev/null | base64 -d || true
echo
echo
echo "===== PART 2 COMPLETE ====="
