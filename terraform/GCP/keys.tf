resource "tls_private_key" "master_node_ssh_keys" {
    algorithm = "RSA"
    rsa_bits  = 4096
    count = var.master_node_count
}

resource "local_file" "ish_bot_kube_master_node_keys" {
    count = var.master_node_count
    content = tls_private_key.master_node_ssh_keys[count.index].private_key_pem
    filename = "./${var.ssh_path}/ish-bot-master-node-${count.index}.key"
}

resource "tls_private_key" "worker_node_ssh_keys" {
    algorithm = "RSA"
    rsa_bits  = 4096
    count = var.worker_node_count
}

resource "local_file" "ish_bot_kube_worker_node_keys" {
    count = var.worker_node_count
    content = tls_private_key.worker_node_ssh_keys[count.index].private_key_pem
    filename = "./${var.ssh_path}/ish-bot-worker-node-${count.index}.key"
}