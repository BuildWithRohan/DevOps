#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/continuous-deployment-on-kubernetes"
PROJECT_ID="$(gcloud config get-value project)"
ZONE="$(gcloud config get-value compute/zone)"
git checkout -b new-feature 2>/dev/null || git checkout new-feature
sed -i 's/blue/orange/g' sample-app/html.go 2>/dev/null || true
sed -i 's/1\.0\.0/2.0.0/g' sample-app/html.go 2>/dev/null || true
git add .
git commit -m "Change application for canary release" 2>/dev/null || true
echo "Development branch prepared."
echo "Jenkins must index the branch before its pipeline can deploy the canary."
echo "PART 3 COMPLETE"