output "ish_bot_kube_master_eip" {
    value = google_compute_address.ish_bot_kube_master_ip.address
}

output "ish_bot_kube_master_public_ips" {
    value = google_compute_instance.ish_bot_kube_master[*].network_interface[*].access_config[*].nat_ip
}

output "ish_bot_kube_worker_public_ips" {
    value = google_compute_instance.ish_bot_kube_worker[*].network_interface[*].access_config[*].nat_ip
}