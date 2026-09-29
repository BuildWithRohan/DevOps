#!/usr/bin/env bash
set -euo pipefail
ZONE="$(gcloud config get-value compute/zone 2>/dev/null)"
CLUSTER="jenkins-cd"
gcloud storage cp gs://spls/gsp051/continuous-deployment-on-kubernetes.zip "$HOME/continuous-deployment-on-kubernetes.zip"
rm -rf "$HOME/continuous-deployment-on-kubernetes"
unzip -q "$HOME/continuous-deployment-on-kubernetes.zip" -d "$HOME/"
cd "$HOME/continuous-deployment-on-kubernetes"
if ! gcloud container clusters describe "$CLUSTER" --zone "$ZONE" >/dev/null 2>&1; then
  gcloud container clusters create "$CLUSTER" --zone "$ZONE" --num-nodes 2 --machine-type e2-standard-2 --scopes "https://www.googleapis.com/auth/source.read_write,cloud-platform"
fi
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
helm repo add jenkins https://charts.jenkins.io 2>/dev/null || true
helm repo update
if ! helm status cd >/dev/null 2>&1; then
  helm install cd jenkins/jenkins -f jenkins/values.yaml --wait
fi
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=default:cd-jenkins 2>/dev/null || true
kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=cd --timeout=10m
echo "PART 1 COMPLETE"