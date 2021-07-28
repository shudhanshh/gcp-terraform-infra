#!/bin/bash

# grant permissions to the workload identity
# Create a namespace
kubectl create namespace $KSA_NAMESPACE

SERVICE_ACCOUNT=${GCP_SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com

# Create a Google Service Account
kubectl create serviceaccount --namespace $KSA_NAMESPACE $KSA_NAME
gcloud iam service-accounts create $GCP_SA_NAME

# Allow a workload identity to impersonate service account
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:${PROJECT_ID}.svc.id.goog[${KSA_NAMESPACE}/${KSA_NAME}]" \
  $SERVICE_ACCOUNT

# Annotate KSA with Google Service Account
kubectl annotate serviceaccount --overwrite\
  --namespace $KSA_NAMESPACE \
  $KSA_NAME \
  iam.gke.io/gcp-service-account=$SERVICE_ACCOUNT

# Use following command to test
kubectl run -it \
--image google/cloud-sdk:slim \
--serviceaccount $KSA_NAME \
--namespace $KSA_NAMESPACE \
workload-identity-test

# Grant permissions to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/datastore.user

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/storage.objectAdmin

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/storage.admin

