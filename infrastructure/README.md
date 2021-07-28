## Scripts to create cluster

We create a private autopilot cluster to take advantage of automatic autoscaling. 

During the development (or for the cluster used for development down the road), it probably does not make sense to run this cluster 24 hours a day, we can shut it down using
the . ./delete-cluster.sh script. To automate it later, we can employ cloud scheduler or other auto shutdown mechanisms.


For now, just run . ./delete-cluster.sh when the cluster is no longer needed.


### Running
Before running scripts, please execute the script below to set env. variables

```
. ./set-env.sh
```

Before running scripts for the first time, please review variables used by each script. For example, you can change the following variables to match your environment, such as
the project name, region, etc.
```
PROJECT_ID="infra-k8s-d-usc1"
gcloud config set project $PROJECT_ID
ENV="d"
REGION="us-east1"
LOCATION="use1"
CLUSTER_NAME="inf-${PROJECT_ID}-k8s-${ENV}-${LOCATION}-poc"
```

1. This task needs to be run once. Run init-networking to create Cloud NAT router to allow external eggress from the nodes.

2. Run . ./start-autopilot-cluster.sh. or . ./start-cluster.sh It will create a GKE cluster. It takes 3-5 min. to create it

While first script creates GKE cluster in the autopilot mode, the second one creates regular cluster 
with preemtable nodes. See this [article](https://cloud.google.com/blog/products/containers-kubernetes/cutting-costs-with-google-kubernetes-engine-using-the-cluster-autoscaler-and-preemptible-vms)
for tips on optimizing GKE costs.

3. When no longer needed, please run delete-cluster.sh

## Deployment

If cluster was restarted / recreated, you can run
```
. ./deploy.sh
```

This script will deploy following objects:
 
1. Deployment [deployment.yaml](deployment.yaml). This deploys the actual
container image. 

You can re-deploy a new image in few different ways. Few of them:

1.1
 ```
. ./set-env.sh

gcloud container clusters get-credentials $CLUSTER_NAME \
    --region $REGION \
    --project=$PROJECT_ID

kubectl delete -f deployment.yaml
kubectl apply -f deploymemnt.yaml
```

Alternatively, you can just apply the deployment. But for the update to happen, you'd need to make
changes to the container template inside the deployment.yaml.

We recommend establishing a CI/CD pipeline using Cloud Build and Kustomize tool. 

1.2 Use GCP ![console](img/rolling-update.png). 

2. Service [service.yaml](service.yaml). It exposes our deployments as a
service.

3. [GKE Ingress for Internal HTTP(s) Balancer](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress-ilb)
We need ingress to expose our deployment via HTTP(S) and load balance accross our pods.

Internal load balancer requires creation of internal proxy subnet. We created cbt-proxy-only-subnet-us-east1.
See the [init-networking.sh](init-networking.sh) for command that was used.

The ingress ojbects creates internal load balancer and the internal IP address.
Deployment of the ingress takes 1-3 minutes. To check the status of the deployment
you can run 
```
kubectl get ingress ilb-ingress
```

Additionally, we use the private Cloud DNS zone - gcp.cannonballtrading.com to
map gcp.cannonballtrading.com to the IP address exposed by the ingress. Notice,
the IP address in the settings may change when ingress is redeployed.
![Private DNS](img/dns.png)

You can access the endpoint only from your internal framework. Hence, to test it using
curl or other means, you will need an jump host.You can start the jump host using
```
. ./start-jump-vm.sh
```

## IAM for the GKE Cluster

Cluster uses the [workload identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
 
The service account that essentially controls permissions needed for the container is
 **svc-gcp-XXXX@cbt-dev-freelance.iam.gserviceaccount.com** 
 
If you need to grant additional permissions
```
. ./set-env.sh
. ./init-iam.sh
```

## Debugging Workloads

Sometimes it is helpful to login to pods to see what is running inside and test connectivity:

Logging into the pod:

```
. ./set-env.sh

gcloud container clusters get-credentials $CLUSTER_NAME \
    --region $REGION \
    --project=$PROJECT_ID

kubectl get pods -n stan-ns

... You will see something like this  ...

NAME                                  READY   STATUS    RESTARTS   AGE
XXXX-server-f4754cccd-f4jvk   1/1     Running   0          15h
XXXX-server-f4754cccd-prgpz   1/1     Running   0          15h
XXXX-server-f4754cccd-thtcf   1/1     Running   0          15h
----------
kubectl exec -it XXXX-server-f4754cccd-thtcf -n stan-ns -- /bin/bash

... you can use curl 0.0.0.0:8080 to connect to HTTP server
```

