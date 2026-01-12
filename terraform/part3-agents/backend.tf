terraform {
  backend "gcs" {
    bucket  = "bindplane-tf-state-demo1"
    prefix  = "bindplane/part3-agents"
  }
}
