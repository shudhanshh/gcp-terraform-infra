#!/bin/bash
#

#  Create cluster regional cluster using create-cluster.sh

echo "Creating the cluster"
bash xyz-Dev-Project/create-cluster.sh || echo "failed to create the cluster"


echo " the cluster is created "


echo " Go to GCP console click to the cluster xyz-dev-freelance click to connect "
sleep 2

echo " You will gcloud command to connect cluster run it on terminal "

sleep 2

echo " Now run deploy-termination.handler.sh "
