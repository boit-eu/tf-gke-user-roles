terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
# Admin User Berechtigungen
resource "google_project_iam_member" "admin_cluster_admin" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"
  member  = "user:${var.admin_user}"
}

resource "google_project_iam_member" "admin_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "user:${var.admin_user}"
}

# Reader User Berechtigungen
resource "google_project_iam_member" "reader_cluster_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "user:${var.reader_user}"
}

resource "google_project_iam_member" "reader_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "user:${var.reader_user}"
}

# Optional: Compute Viewer für beide (um Nodes zu sehen)
resource "google_project_iam_member" "admin_compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "user:${var.admin_user}"
}

resource "google_project_iam_member" "reader_compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "user:${var.reader_user}"
}

# Outputs
output "assigned_roles" {
  value = {
    admin_user = [
      "roles/container.clusterAdmin",
      "roles/container.developer",
      "roles/compute.viewer"
    ]
    reader_user = [
      "roles/container.clusterViewer", 
      "roles/container.developer",
      "roles/compute.viewer"
    ]
  }
}