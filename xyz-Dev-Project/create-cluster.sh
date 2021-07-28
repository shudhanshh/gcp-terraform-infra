#!/bin/bash
#

#  Create cluster zonal cluster in standard mode with premptible node in us-east1-a zone with two node pools

# One node pool is default and the other one with premptible vm

# Used below gcloud command which will create a new cluster


#Setting environment variable

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

gcloud beta container --project $PROJECT_ID clusters create $CLUSTER_NAME \
--zone $ZONE --no-enable-basic-auth --cluster-version "1.19.9-gke.1400" --release-channel "regular" \
--machine-type $MACHINE_TYPE --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" \
--metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" \
--preemptible --num-nodes "3" --enable-stackdriver-kubernetes --enable-ip-alias \
--network "projects/xyz-dev-freelance/global/networks/default" \
--subnetwork "projects/xyz-dev-freelance/regions/us-east1/subnetworks/default" \
--no-enable-intra-node-visibility --default-max-pods-per-node "110" --enable-autoscaling \
--min-nodes "3" --max-nodes "6" --no-enable-master-authorized-networks \
--enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 \
--enable-autoprovisioning --min-cpu 1 --max-cpu 1 --min-memory 1 --max-memory 1 \
--autoprovisioning-scopes=https://www.googleapis.com/auth/cloud-platform --enable-autoprovisioning-autorepair \
--enable-autoprovisioning-autoupgrade --autoprovisioning-max-surge-upgrade 1 --autoprovisioning-max-unavailable-upgrade 0 \
 --node-locations $ZONE && gcloud beta container \
--project $PROJECT_ID node-pools create "default-node-pool" \
--cluster $CLUSTER_NAME --zone $ZONE --machine-type $MACHINE_TYPE \
--image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" \
--metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" \
--num-nodes "1" --enable-autoscaling --min-nodes "1" --max-nodes "1" --enable-autoupgrade \
--enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --node-locations $ZONE
