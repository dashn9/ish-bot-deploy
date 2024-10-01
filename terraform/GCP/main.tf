provider "google" {
  project = var.project_id
  region  = var.region
  zone = "${var.region}-a"
  credentials = file(".gcp_credentials")
}
