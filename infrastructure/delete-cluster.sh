#!/bin/bash

# Run . set-env.sh before running this script

# Create cluster. Initially we try to use autopilot cluster to help us automatically determine autoscaling for the workloads
# we use. Once it is determine, we may need to deside whether it is more practical to switch to conventional
gcloud container clusters delete $CLUSTER_NAME