
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (for provider)"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for the VM"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name of the control plane VM"
  type        = string
  default     = "bp-control-plane"
}

variable "machine_type" {
  description = "GCE machine type"
  type        = string
  default     = "e2-micro"
}

variable "image" {
  description = "Boot image (e.g., debian-12)"
  type        = string
  default     = "debian-12"
}

# --- Postgres / Cloud SQL parameters passed to BindPlane ---
variable "db_host" {
  description = "PostgreSQL host (IP or hostname)"
  type        = string
}

variable "db_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "db_user" {
  description = "Database application user (BindPlane DB user)"
  type        = string
}

variable "db_admin" {
  description = "Database admin user (e.g., postgres)"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Password for the database user/admin as required"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name BindPlane should use"
  type        = string
  default     = "bindplane"
}

variable "admin_password" {
  description = "BindPlane UI admin password"
  type        = string
  sensitive   = true
}
