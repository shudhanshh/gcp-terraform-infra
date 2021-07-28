#!/bin/bash


#Deploy the k8s-node-termination-handler
#Ref : https://github.com/GoogleCloudPlatform/k8s-node-termination-handler

echo "Deploying the k8s-node-termination-handler on the cluster"

kubectl apply -f xyz-Dev-Project/deploy/


#Deploy the test deamonset (1 pod on each node) to see if it gets scheduleded on another node before node gets deleted

echo "Deploy the test deamonset"
kubectl apply -f xyz-Dev-Project/test.yaml
