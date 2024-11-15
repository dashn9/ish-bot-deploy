variable "name_prefix" {
    default = "ish-bot"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "availability_zone" {
    default = "us-east-1"
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
    default = "t4g.micro"
}

variable "master_node_image" {
    default = "ami-0789039e34e739d67" # Debian
}

variable "master_node_name" {
    default = "ish_bot_kube_master"
}

variable "master_node_user" {
    default =  "admin"
}

variable "master_node_root_storage_size" {
    default = 8
}

variable "master_node_root_storage_type" {
    default = "gp3"
}

variable "master_node_count" {
    default = 1
}


variable "worker_node_type" {
    default = "c6g.xlarge"
}

variable "worker_node_image" {
    default = "ami-0789039e34e739d67" # Debian
}

variable "worker_node_name" {
    default = "ish_bot_kube_worker"
}

variable "worker_node_user" {
    default =  "admin"
}

variable "worker_node_root_storage_size" {
    default = 15
}

variable "worker_node_root_storage_type" {
    default = "gp3"
}

variable "worker_node_count" {
    default = 1
}
