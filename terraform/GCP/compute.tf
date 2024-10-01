resource "google_compute_instance" "k8s_master_node" {
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "${var.master_node_image}"
      size  = "${var.master_node_root_storage_size}"
      type = "${var.master_node_root_storage_type}"
    }
  }

  can_ip_forward = true
  count          = "${var.master_node_count}"
  machine_type   = "${var.master_node_type}"
  name           = "k8s-master_node${count.index}"

  network_interface {
    subnetwork    = "${google_compute_subnetwork.k8s_subnet.name}"
  }

  metadata = {
    ssh-keys = "your-ssh-user:${tls_private_key.master_node_ssh_keys[count.index].public_key_openssh}"
  }
  
  # There is a cleaner way to move these files below
  connection {
    type        = "ssh"
    user        = var.master_node_user
    private_key = file("${var.ssh_path}/${var.master_node_name}-${count.index}.key")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${var.certificates_path}/k8s-ca.crt"
    destination = "/home/${var.master_node_user}/k8s-ca.crt"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/k8s-ca.key"
    destination = "/home/${var.master_node_user}/k8s-ca.key"
  }

  # Upload Kubernetes API Server key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/kubernetes-apiserver.key"
    destination = "/home/${var.master_node_user}/kubernetes-apiserver.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kubernetes-apiserver.crt"
    destination = "/home/${var.master_node_user}/kubernetes-apiserver.crt"
  }

  # Upload Kubernetes API Server Kubelet client key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/kubernetes-apiserver-kubelet-client.key"
    destination = "/home/${var.master_node_user}/kubernetes-apiserver-kubelet-client.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kubernetes-apiserver-kubelet-client.crt"
    destination = "/home/${var.master_node_user}/kubernetes-apiserver-kubelet-client.crt"
  }

  # Upload Kubernetes master_node Manager key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/kube-master_node-manager.key"
    destination = "/home/${var.master_node_user}/kube-master_node-manager.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kube-master_node-manager.crt"
    destination = "/home/${var.master_node_user}/kube-master_node-manager.crt"
  }

  # Upload Kubernetes Scheduler key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/kube-scheduler.key"
    destination = "/home/${var.master_node_user}/kube-scheduler.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kube-scheduler.crt"
    destination = "/home/${var.master_node_user}/kube-scheduler.crt"
  }

  # Upload Admin key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/admin.key"
    destination = "/home/${var.master_node_user}/admin.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/admin.crt"
    destination = "/home/${var.master_node_user}/admin.crt"
  }

  # Upload ETCD client key and certificate
  provisioner "file" {
    source      = "${var.certificates_path}/etcd.key"
    destination = "/home/${var.master_node_user}/etcd.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/etcd.crt"
    destination = "/home/${var.master_node_user}/etcd.crt"
  }
  provisioner "file" {
    source      = "${var.certificates_path}/service-accounts.key"
    destination = "/home/${var.master_node_user}/service-accounts.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/service-accounts.crt"
    destination = "/home/${var.master_node_user}/service-accounts.crt"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_admin_config.sh"
    destination = "/home/${var.master_node_user}/generate_admin_config.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_master_node_manager_config.sh"
    destination = "/home/${var.master_node_user}/generate_master_node_manager_config.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_scheduler_config.sh"
    destination = "/home/${var.master_node_user}/generate_scheduler_config.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/install_control_plane.sh"
    destination = "/home/${var.master_node_user}/install_control_plane.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/start_control_plane.sh"
    destination = "/home/${var.master_node_user}/start_control_plane.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/start_etcd.sh"
    destination = "/home/${var.master_node_user}/start_etcd.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/create_rbac.sh"
    destination = "/home/${var.master_node_user}/create_rbac.sh"
  }

  provisioner "file" {
    source      = "${var.configs_path}/gens/encryption-config.yaml"
    destination = "/home/${var.master_node_user}/encryption-config.yaml"
  }

  provisioner "file" {
    source      = "${var.configs_path}/coredns.yaml"
    destination = "/home/${var.master_node_user}/coredns.yaml"
  }

  provisioner "remote-exec" {

    inline = [
      "sudo chmod +x generate_admin_config.sh generate_master_node_manager_config.sh generate_scheduler_config.sh install_control_plane.sh start_control_plane.sh start_etcd.sh",
      "./install_control_plane.sh",
      "./generate_master_node_manager_config.sh",
      "./generate_scheduler_config.sh",
      "./generate_admin_config.sh",
      "./start_etcd.sh",
      "./start_control_plane.sh",
    ]
  }
}





resource "google_compute_instance" "ish_bot_kube_worker" {
  count        = var.worker_node_count
  name         = "${var.worker_node_name}-${count.index}"
  machine_type = var.worker_node_type
  tags         = ["kubernetes-cluster"]

  boot_disk {
    initialize_params {
      image  = var.worker_node_image
      size   = var.worker_node_root_storage_size
      type   = var.worker_node_root_storage_type
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnets[count.index].self_link
    access_config {
      # This block gives the instance external access
    }
  }

  service_account {
    email  = google_service_account.pd_csi_service_account.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<-EOF
                #!/bin/bash
                echo "POD_CIDR=10.244.${count.index}.0/24" >> /etc/environment
            EOF

  metadata = {
    ssh-keys = "your-ssh-user:${tls_private_key.worker_node_ssh_keys[count.index].public_key_openssh}"
  }

  connection {
    type        = "ssh"
    user        = var.worker_node_user
    private_key = file("${var.ssh_path}/${var.worker_node_name}-${count.index}.key")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "${var.certificates_path}/k8s-ca.crt"
    destination = "/home/${var.worker_node_user}/k8s-ca.crt"
  }
  # The only reason i'm passing the private key to the worker node, is so it can generate it's require certs, delete if cert has been created
  provisioner "file" {
    source      = "${var.certificates_path}/k8s-ca.key"
    destination = "/home/${var.worker_node_user}/k8s-ca.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kube-proxy.key"
    destination = "/home/${var.worker_node_user}/kube-proxy.key"
  }

  provisioner "file" {
    source      = "${var.certificates_path}/kube-proxy.crt"
    destination = "/home/${var.worker_node_user}/kube-proxy.crt"
  }


  provisioner "file" {
    source      = "${var.scripts_path}/generate_proxy_config.sh"
    destination = "/home/${var.worker_node_user}/generate_proxy_config.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_kubelet_config.sh"
    destination = "/home/${var.worker_node_user}/generate_kubelet_config.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_certificate.sh"
    destination = "/home/${var.worker_node_user}/generate_certificate.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/generate_cluster_worker_certificates.sh"
    destination = "/home/${var.worker_node_user}/generate_cluster_worker_certificates.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/install_worker.sh"
    destination = "/home/${var.worker_node_user}/install_worker.sh"
  }

  provisioner "file" {
    source      = "${var.scripts_path}/start_worker.sh"
    destination = "/home/${var.worker_node_user}/start_worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x generate_cluster_worker_certificates.sh generate_kubelet_config.sh generate_proxy_config.sh install_worker.sh start_worker.sh",
      "./install_worker.sh",
      "./generate_cluster_worker_certificates.sh .",
      # In the future, when you create multiple master nodes for HA, you would want to use a load balance and attach a single publics ip to the entire cluster
      "./generate_kubelet_config.sh ${aws_eip.ish_bot_kube_master_eip[0].public_ip}",
      "./generate_proxy_config.sh ${aws_eip.ish_bot_kube_master_eip[0].public_ip}",
      "./start_worker.sh",
    ]
  }

}

resource "local_file" "master_node_ssh_keys" {
  count    = var.master_node_count
  content  = tls_private_key.master_node_ssh_keys[count.index].private_key_pem
  filename = "${var.master_node_name}-${count.index}.key"
}

resource "local_file" "worker_node_ssh_keys" {
  count    = var.worker_node_count
  content  = tls_private_key.worker_node_ssh_keys[count.index].private_key_pem
  filename = "${var.worker_node_name}-${count.index}.key"
}
