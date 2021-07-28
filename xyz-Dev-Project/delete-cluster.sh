#!/bin/bash
#Script to delete the created cluster

PROJECT_ID="xyz-dev-freelance"
ENV="dev"
REGION="us-east1"
ZONE="us-east1-b"
PREFIX="xyz"
CLUSTER_NAME="${PREFIX}-${ENV}-cluster"
MACHINE_TYPE="n2-standard-2"
NETWORK="default"

echo $PROJECT_ID
echo $ENV
echo $REGION
echo $ZONE
echo $PREFIX
echo $CLUSTER_NAME
echo $MACHINE_TYPE
echo $NETWORK

gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION

gcloud container clusters delete $CLUSTER_NAME
