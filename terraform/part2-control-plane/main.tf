############################################
# Provider
############################################
provider "google" {
  project = var.project_id
  region  = var.region
}

############################################
# Remote State – Part 1 (Cloud SQL)
############################################
data "terraform_remote_state" "db" {
  backend = "gcs"
  config = {
    bucket = "bindplane-tf-state-demo"
    prefix = "bindplane/part1-db"
  }
}

############################################
# BindPlane Control Plane VM
############################################
resource "google_compute_instance" "control_plane" {
  name         = "bp-control-plane"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-12"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<SCRIPT
#!/usr/bin/env bash
set -euo pipefail

echo "Updating OS and installing prerequisites..."
apt-get update -y
apt-get install -y \
  curl \
  jq \
  ca-certificates \
  gnupg

echo "Adding ObservIQ GPG key..."
curl -fsSL https://packages.observiq.com/apt/repo-signing-key.gpg \
  | gpg --dearmor -o /usr/share/keyrings/observiq.gpg

echo "Adding ObservIQ APT repository..."
echo "deb [signed-by=/usr/share/keyrings/observiq.gpg] https://packages.observiq.com/apt stable main" \
  > /etc/apt/sources.list.d/observiq.list

echo "Updating package index..."
apt-get update -y

echo "Installing BindPlane Control Plane..."
apt-get install -y bindplane

echo "Configuring BindPlane with Cloud SQL PostgreSQL..."
bindplane setup \
  --db-host ${data.terraform_remote_state.db.outputs.db_host} \
  --db-port ${data.terraform_remote_state.db.outputs.db_port} \
  --db-user ${data.terraform_remote_state.db.outputs.db_user} \
  --db-password ${var.db_password} \
  --db-name ${data.terraform_remote_state.db.outputs.db_name} \
  --admin-password ${var.admin_password}

echo "BindPlane Control Plane installation and configuration completed"
SCRIPT

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

############################################
# Outputs
############################################
output "control_plane_ip" {
  description = "Public IP of BindPlane Control Plane"
  value       = google_compute_instance.control_plane.network_interface[0].access_config[0].nat_ip
}
