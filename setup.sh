#!/bin/bash

# BEFORE RUNNING
# Set Environment Variables

# GIT variables
GITHUB_USER="barnacleDevelopments"

# Define Flux Variables
FLUX_REPO_NAME="flux-config"
FLUX_BRANCH="master"
FLUX_COMPONENTS="image-reflector-controller,image-automation-controller"
FLUX_CLUSTER_NAME="app-cluster"

# Define node-ts-api variables
NODE_TS_API_BRANCH="version_3"
NODE_TS_API_NAME="node-ts-api"
NODE_TS_API_GIT_URL="https://github.com/barnacleDevelopments/kubernetes-test"
NODE_TS_API_INTERVAL="1m"

# Azure Variables
AZ_RS_GROUP="KubernetesTest"
AZ_AKS_NAME="devdeveloper-aks-cluster"
AZ_SUBSCRIPTION_ID="59966e90-8185-44af-a00c-13bc237e59cb"

# DEPLOY RESOURCES
cd ./iac
terraform apply
cd ../

AKS_OBJECT_ID=$(az aks show --resource-group $AZ_RS_GROUP --name $AZ_AKS_NAME --query "identityProfile.kubeletidentity.objectId" -o tsv)

az role assignment create \
    --assignee $AKS_OBJECT_ID \
    --role "AcrPull" \
    --scope "/subscriptions/$AZ_SUBSCRIPTION_ID/resourceGroups/KubernetesTest/providers/Microsoft.ContainerRegistry/registries/devdeveloperregistry"

az aks get-credentials --resource-group KubernetesTest --name devdeveloper-aks-cluster

# CONFIGURE FLUX
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$FLUX_REPO_NAME \
  --branch=$FLUX_BRANCH \
  --path="./clusters/$FLUX_CLUSTER_NAME" \
  --personal \
  --components-extra=$FLUX_COMPONENTS \
  --read-write-key=true

git clone "git@github.com:$GITHUB_USER/$FLUX_REPO_NAME.git"

cd $FLUX_REPO_NAME

flux create source git flux-kubernetes-app \
  --url=$NODE_TS_API_GIT_URL \
  --branch=$NODE_TS_API_BRANCH \
  --interval=$NODE_TS_API_INTERVAL \
  --export > ./clusters/$FLUX_CLUSTER_NAME/flux-node-ts-api-source.yaml

cat ../flux-config.yaml > ./clusters/$FLUX_CLUSTER_NAME/flux-node-ts-api-source.yaml

flux create kustomization flux-kubernetes-app \
  --target-namespace="default" \
  --source=$NODE_TS_API_NAME \
  --path="./manifests/overlays/prod" \
  --prune="true" \
  --wait="true" \
  --interval="30m" \
  --retry-interval="2m" \
  --health-check-timeout="3m" \
  --export > ./clusters/$FLUX_CLUSTER_NAME/flux-node-ts-api-kustomization.yaml

git add -A && git commit -m "Add flux-kubernetes-test Kustomization"
git push
cd ../
rm -r $FLUX_REPO_NAME
