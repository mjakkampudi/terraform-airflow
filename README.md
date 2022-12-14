# Airflow Deployment on GKE using HELM and Terraform

## Getting Started
I have run this code using a MacBook.
- Clone this repo
- Install the prerequisites
- Follow the instructions mentioned below
- Check http://localhost:8080 
- You should be able to login to airflow using the credentials provided in the code (default username & password: admin, admin)

### Infrastructure on GCP
- Provisioned a GKE cluster and GCS bucket on GCP using Terraform.
- Deploy Airflow on GKE using Helm chart.

### Prerequisites
- Create GCP account
- Terraform on local machine
- PyCharm on local machine

### Instructions 
- Check if your mac has HomeBrew installed: ___brew___
- Install Terraform: ___brew install terraform___
- Verify if Terraform was successfully installed: ___terraform -v___
- Install Kubernetes command line interface: ___brew install kubernetes-cli___
- Verify if you are able to use kubernetes cli: ___kubectl___
- Install google cloud SDK: ___brew install --cask google-cloud-sdk___
- Install google cloud auth plugin: 
  - ___gcloud components install gke-gcloud-auth-plugin___ 
  - ___gcloud init___
  - ___gcloud auth application-default login___
- Get kubernetes context and start using it on local machine: ___gcloud container clusters get-credentials (\$(terraform output -raw kubernetes_cluster_name) --region \$(terraform output -raw region))___
- If you want to visualise your Kubernetes clusters on your local machine you can install lens: ___brew install --cask lens___
- I have enabled GitSync to my private repo for DAG synchronization, if you dont want it you can simply set [___enable: false.___](https://github.com/mjakkampudi/terraform-airflow/blob/1af48fb6732b1ca14d40b8ea1793185a355fced9/resources/airflow-values.yaml#L1308)
- If you wish to enable GitSync, follow further instructions below to customize the ___helm chart___ using ___values.yaml.___

### Instructions to enable GitSync:
- Create private git repo
- Generate ssh key: ___ssh-keygen -t rsa -b 4096 -C "email"___
- Go to your repo settings, find deploy keys and add new key ___airflow_ssh_dags___
- Run this in command line to open your key file: ___cat  ~./.ssh/airflowsshkey.pub___
- Copy everything from the file and paste it in your git when adding the new key. Enable write access.
- Create kubctl secret inside your cluster:
  - Check where you are creating your secret: ***k config get-contexts***
  - Create Secret: ***kubectl create secret generic \
           airflow-git-ssh-secret \
           --from-file=id_rsa=$HOME/.ssh/id_rsa \
           --namespace your-namespace***
- Go to values.yaml on pycharm and look for GitSync and update (it has already been updated in the code):
    - enable : true
    - repo: ssh://git@github.com:username/private-repo-name.git
    - branch: main
    - rev: HEAD
    - depth: 1
    - credentialsSecret: git-credentials
    - sshKeySecret: airflow-git-ssh-secret
- To save money when not using GCP resources we can use ***terraform destroy***
- If we destroy the resources our SSH key also gets destroyed in the process. To avoid manually creating the key 
everytime we can create a kubernetes secret for the private ssh key via terraform from the specified 
path. I added the private key file to my local repo but omitted it from the remote repo by adding it to .gitignore following best practices.

### Final Steps
Once you have updated everything according to the instructions here and within the code you can use the commands below:
 - Initialize terraform: ___terraform init___
 - Check if plan looks good: ___terraform plan___
 - Apply changes: ***terraform apply -auto-approve***
 - Check if your airflow web service has been created: ***kubectl get svc***
 - Enable port forwarding for airflow web service: ***kubectl port-forward svc/airflow-helm-web 8080:8080***
  

