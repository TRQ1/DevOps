resource "google_compute_network" "default" {
  name                    = "docker-net"
  auto_create_subnetworks = "true"
}

#resource "google_compute_subnetnetwork" "default-us-central1" {
#  name          = "default-us-central1"
#  ip_cidr_range = "10.16.16.0/24"
#  network       = "${google_compute_network.default.self_link}"
#  region        = "${var.gcp_region}"
#}

resource "google_compute_firewall" "default" {
  name    = "docker"
  network = "docker-net"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "2377", "2375", "7946", "4789", "4749"]
  }
}
