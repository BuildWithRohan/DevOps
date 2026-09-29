#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/continuous-deployment-on-kubernetes"
PROJECT_ID="$(gcloud config get-value project)"
ZONE="$(gcloud config get-value compute/zone)"
gcloud container clusters get-credentials jenkins-cd --zone "$ZONE"
echo "Project: $PROJECT_ID"
echo "Jenkins admin password:"
printf '%s\n' "$(kubectl get secret cd-jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode)"
kubectl get pods
echo "PART 2: Jenkins is installed. The lab's remaining Jenkins job setup uses the sample-app Cloud Source Repository:"
echo "https://source.developers.google.com/p/$PROJECT_ID/r/default"
echo "PART 2 COMPLETE"