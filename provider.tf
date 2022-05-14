provider "google" {
  credentials = file("${path.module}/service-account.json")
  project     = var.project
  region      = var.region
}