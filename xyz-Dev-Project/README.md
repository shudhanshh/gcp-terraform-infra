#Run the automation1.sh first to create cluster use command below


bash xyz-Dev-Project/create-preemptible-cluster.sh



#Run the deploy-termination.handler.sh to Deploy the k8s-node-termination-handler and test deployment using below command

bash xyz-Dev-Project/deploy-termination.handler.sh



# We will deloy test elasticsearch pods using test.yaml
# This is just test deployment to deploy the pod on each node
