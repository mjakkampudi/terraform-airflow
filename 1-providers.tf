provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
    kubernetes = {
      source = "hashicorp/helm"
      version = "2.5.1"
      source = "hashicorp/kubernetes"
      version = ">= 2.10.0"
    }
    kubectl ={
      source = "gavinbunney/kubectl"
      version ="=1.14.0"
    }
  }

  required_version = ">= 0.14"
}

data "google_client_config" "provider" {}

provider "kubernetes"  {
  config_path = "~/.kube/config"
  config_context = "gke_data-eng1_us-central1_data-eng1-gke"
  host = google_container_cluster.primary.endpoint
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)

}

provider "helm" {
  kubernetes {
    config_context = "~/.kube/config"
    host = google_container_cluster.primary.endpoint
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)

  }
}

# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only.
# # It references the variables and resources provisioned in this file.
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

#provider "kubernetes" {
# load_config_file = "false"
#
# host     = google_container_cluster.primary.endpoint
# username = var.gke_username
# password = var.gke_password
#
# client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
# client_key             = google_container_cluster.primary.master_auth.0.client_key
# cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
#}