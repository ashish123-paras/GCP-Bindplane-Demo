output "control_plane_ip" {
  value = data.terraform_remote_state.control_plane.outputs.control_plane_ip
}

