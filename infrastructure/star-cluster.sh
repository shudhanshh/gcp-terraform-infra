#!/bin/bash

# Run . set-env.sh before running this script

# Create cluster regional cluster
gcloud services enable container.googleapis.com 

echo 'Creating GKE cluster: ' $CLUSTER_NAME

# Create cluster with 2 preemtable nodes
gcloud container clusters create $CLUSTER_NAME \
    --region=$REGION \
    --project=$PROJECT_ID \
    --preemptible \
    --num-nodes 2 \
    --enable-private-nodes

# To save time, we get credentials to access cluster automatically
gcloud container clusters get-credentials $CLUSTER_NAME \
    --region $REGION \
    --project=$PROJECT_ID
