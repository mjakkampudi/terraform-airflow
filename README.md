# Airflow Deployment on GKE using HELM and Terraform

## Getting Started
I have run this code using a MacBook.
Follow these instructions to copy the code to your local machine.
- Clone this repo
- Install the prerequisites
- Check http://localhost:8080. 
- You should be able to login to airflow using the credentials provided in the code.

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
- Install google cloud auth plugin: ___gcloud components install gke-gcloud-auth-plugin___ 
- Get kubernetes context and start using it on local machine: ___gcloud container clusters get-credentials (\$(terraform output -raw kubernetes_cluster_name) --region \$(terraform output -raw region))___
- If you want to visualise your Kubernetes clusters on your local machine you can install lens: ___brew install --cask lens___
- I have enabled GitSync to my private repo for DAG synchronization, if you dont want it you can simply set ___enable: false.___
- If you wish to enable GitSync as well, follow further instructions below to customize the ___helm chart___ using ___values.yaml.___

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

### Final Steps
- Once you have updated everything according to the instructions here and within the code you can use the commands below:
  - Initialize terraform: ___terraform init___
  - Check if plan looks good: ___terraform plan___
  - Apply changes: ***terraform apply -auto-approve***
  

