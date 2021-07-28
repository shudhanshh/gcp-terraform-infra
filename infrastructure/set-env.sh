#!/bin/bash

# Create cluster. Initially we try to use autopilot cluster to help us automatically determine autoscaling for the workloads
# we use. Once it is determine, we may need to deside whether it is more practical to switch to conventional
PROJECT_ID="xyz-dev-freelance"
gcloud config set project $PROJECT_ID
ENV="d"
REGION="us-east1"
gcloud config set compute/region $REGION
LOCATION="use1"
PREFIX="xyz"
CLUSTER_NAME="${PREFIX}-k8s-${ENV}-${LOCATION}"
NAT_ROUTER="${PREFIX}-router-s-${LOCATION}"
NETWORK="default"
APP_NAME="freelance"
KSA_NAMESPACE=stan-ns
KSA_NAME=stan-sa
GCP_SA_NAME=svc-gcp-${APP_NAME}