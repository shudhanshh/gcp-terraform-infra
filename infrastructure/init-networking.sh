#!/bin/bash

# Run . set-env.sh before running this script. This script has been executed and does not need
# to be run again.

# The cluser we create usin start-cluster.sh is private, that is it won't have private IPs. Hence, we need to create Cloud NAT
# to allow nodes to access internet, e.g. download container
gcloud services enable compute.googleapis.com 

# Create NAT router
gcloud compute routers create $NAT_ROUTER \
    --network $NETWORK \
    --region $REGION \
    --project=$PROJECT_ID

# Create configuration for the NAT router
gcloud compute routers nats create allow-external-access \
    --region $REGION \
    --router $NAT_ROUTER \
    --nat-all-subnet-ip-ranges \
    --auto-allocate-nat-external-ips \
    --project=$PROJECT_ID

# reserve static ip
#gcloud compute addresses create ${PREFIX}-ip-${LOCATION} \
#    --global \
#    --ip-version IPV4

gcloud compute addresses create ${PREFIX}-ip-${LOCATION} \
    --region $REGION

#create a proxy only subnet for use by the ingress
#cbt-proxy-only-subnet-us-east1  us-east1  default  10.120.0.0/16
gcloud compute networks subnets create ${PREFIX}-proxy-only-subnet-${REGION} \
    --purpose=INTERNAL_HTTPS_LOAD_BALANCER \
    --role=ACTIVE \
    --region=${REGION} \
    --network=default \
    --range=10.120.0.0/16

# Reserve internal static ip for use by the ingress
gcloud compute addresses create cbt-stan-ip-${REGION} \
    --region $REGION --subnet default \
      --addresses 10.142.0.12