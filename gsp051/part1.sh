#!/usr/bin/env bash
set -euo pipefail
ZONE="us-central1-c"
CLUSTER="jenkins-cd"
gcloud config set compute/zone "$ZONE" >/dev/null
rm -rf "$HOME/continuous-deployment-on-kubernetes" "$HOME/continuous-deployment-on-kubernetes.zip"
gsutil cp gs://spls/gsp051/continuous-deployment-on-kubernetes.zip "$HOME/"
unzip -q "$HOME/continuous-deployment-on-kubernetes.zip" -d "$HOME/"
cd "$HOME/continuous-deployment-on-kubernetes"
if ! gcloud container clusters describe "$CLUSTER" --zone "$ZONE" >/dev/null 2>&1; then
  gcloud container clusters create "$CLUSTER" --zone "$ZONE" --num-nodes=2 --machine-type=e2-standard-2 --scopes="https://www.googleapis.com/auth/source.read_write,cloud-platform"
fi
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
helm repo add jenkins https://charts.jenkins.io 2>/dev/null || true
helm repo update >/dev/null
kubectl create namespace jenkins 2>/dev/null || true
if [ -f "jenkins/values.yaml" ]; then helm upgrade --install cd jenkins/jenkins -n jenkins -f jenkins/values.yaml; else helm upgrade --install cd jenkins/jenkins -n jenkins; fi
kubectl create clusterrolebinding jenkins-deploy --clusterrole=cluster-admin --serviceaccount=jenkins:cd-jenkins 2>/dev/null || true
echo "PART 1 COMPLETE"
kubectl get pods -n jenkins
