terraform {
  backend "gcs" {
    bucket  = "bindplane-tf-state-demo"
    prefix  = "bindplane/part2-control-plane"
  }
}
