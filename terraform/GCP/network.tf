resource "google_compute_network" "k8s_network" {
  auto_create_subnetworks = false
  name                    = "${var.name_prefix}-kube-network"
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name          = "${var.name_prefix}-kubernetes-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.k8s_vpc.id
}

resource "google_compute_route" "k8s_rt" {
  name        = "${var.name_prefix}-kubernetes-rt"
  dest_range  = "10.200.${count.index}.0/24"
  depends_on  = ["google_compute_instance.k8s_worker"]
  network     = google_compute_network.k8s_network.self_link
  next_hop_ip = google_compute_instance.k8s_worker[count.index].network_interface.0.network_ip
  priority    = 100
}

resource "google_compute_firewall" "k8s_if" {
  name    = "${var.name_prefix}-kubernetes-if"
  network = google_compute_network.k8s_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["kubernetes-cluster"]
}
