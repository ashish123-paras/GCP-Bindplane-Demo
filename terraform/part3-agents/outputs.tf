output "control_plane_ip" {
  value = google_compute_instance.bindplane.network_interface[0].access_config[0].nat_ip
}
