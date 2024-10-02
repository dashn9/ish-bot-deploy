variable "project_id" {
  default = "ish-bot"
}

variable "name_prefix" {
  default = "ish-bot"
}

variable "network_cidr" {
  default = "10.0.0.0/16"
}

variable "region" {
  default = "us-central1"
}

variable "ssh_path" {
  default = "./nodes_ssh_keys"
}

variable "certificates_path" {
  default = "~/ish_bot_kube_cluster_certificates/certs"
}

variable "scripts_path" {
  default = "../../scripts/k8s"
}

variable "configs_path" {
  default = "../../scripts/k8s/configs/"
}

variable "master_node_type" {
  default = "e2-small"
}

variable "master_node_image" {
  default = "projects/debian-cloud/global/images/debian-12-bookworm-v20240910" # Debian
}

variable "master_node_name" {
  default = "ish-bot-kube-master"
}

variable "master_node_user" {
  default = "admin"
}

variable "master_node_root_storage_size" {
  default = 10
}

variable "master_node_root_storage_type" {
  default = "pd-balanced"
}

variable "master_node_count" {
  default = 1
}

variable "worker_node_type" {
  default = "n2d-highcpu-8"
}

variable "worker_node_image" {
  default = "projects/debian-cloud/global/images/debian-12-bookworm-v20240910" # Debian
}

variable "worker_node_name" {
  default = "ish-bot-kube-worker"
}

variable "worker_node_user" {
  default = "admin"
}

variable "worker_node_root_storage_size" {
  default = 16
}

variable "worker_node_root_storage_type" {
  default = "pd-balanced"
}

variable "worker_node_count" {
  default = 1
}
