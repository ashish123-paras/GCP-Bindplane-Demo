data "terraform_remote_state" "control_plane" {
  backend = "gcs"
  config = {
    bucket = "bindplane-tf-state-demo1"
    prefix = "bindplane/part2-control-plane"
  }
}
