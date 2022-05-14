terraform {
  backend "gcs" {
    credentials = "service-account.json"
    bucket      = "tf-state-stg1994"
    prefix      = "terraform/state"
  }
}