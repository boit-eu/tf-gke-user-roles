# Variablen
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "europe-west3"
}

variable "admin_user" {
  description = "Admin User Email"
  type        = string
}

variable "reader_user" {
  description = "Reader User Email"
  type        = string
}