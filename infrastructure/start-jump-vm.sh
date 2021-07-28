#!/bin/bash

# Internal ingress can be accessed from vm or resources located in the same region

gcloud compute instances create l7-ilb-client-${REGION}-c \
    --image-family=debian-9 \
    --image-project=debian-cloud \
    --network=default \
    --subnet=default \
    --zone=${REGION}-c \
    --tags=allow-ssh

# SSH to the created vm
gcloud compute ssh l7-ilb-client-us-central1-c \
   --zone=us-central1-c