#!/bin/bash

# Run . set-env.sh before running this script

# Create cluster. Initially we try to use autopilot cluster to help us automatically determine autoscaling for the workloads
# we use. Once it is determine, we may need to deside whether it is more practical to switch to conventional
gcloud services enable container.googleapis.com 

echo 'Creating GKE cluster: ' $CLUSTER_NAME

gcloud container clusters create-auto $CLUSTER_NAME \
    --region=$REGION \
    --project=$PROJECT_ID \
    --enable-private-nodes

# To save time, we get credentials to access cluster automatically
gcloud container clusters get-credentials $CLUSTER_NAME \
    --region $REGION \
    --project=$PROJECT_ID
