terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

variable "project_id" {
  description = "The ID of the project in which resources will be deployed."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy to."
  type        = string
}

variable "key_file" {
  description = "The path to the GCP service account key file."
  type        = string
}

provider "google" {
  credentials = file(var.key_file)
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "gpu_cluster" {
  name               = "gpu-cluster"
  location           = var.region
  initial_node_count = 1
  remove_default_node_pool = true
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "gpu-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gpu_cluster.name
  node_count = 1

  node_config {
    guest_accelerator {
      type = "nvidia-tesla-t4"
      count = 1
      gpu_sharing_config {
        gpu_sharing_strategy = "TIME_SHARING"
        max_shared_clients_per_gpu = 8
      }
    }
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER" 
    }
    machine_type = "n1-standard-4"
    disk_size_gb = 50
    spot = true
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "null_resource" "install_gpu_driver" {
  triggers = {
    cluster_ep = google_container_cluster.gpu_cluster.endpoint #kubernetes cluster endpoint
  }

  provisioner "local-exec" {
    command = <<EOT
      gcloud container clusters get-credentials ${google_container_cluster.gpu_cluster.name} --region ${var.region} --project ${var.project_id}
      kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
    EOT
  }

  depends_on = [google_container_cluster.gpu_cluster]
}

