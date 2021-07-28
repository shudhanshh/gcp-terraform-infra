#!/bin/bash

# Follows example https://cloud.google.com/kubernetes-engine/docs/how-to/internal-load-balance-ingress

#deploy
kubectl apply -f  deployment.yaml
kubectl apply -f  service.yaml
kubectl apply -f  ingress.yaml
