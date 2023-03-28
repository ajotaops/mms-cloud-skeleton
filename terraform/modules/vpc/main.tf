resource "google_compute_network" "default" {
  name                    = "vpc-${var.name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  for_each = var.vpcs
  name          = "subnet-${var.name}"
  region        = each.key
  ip_cidr_range = each.value
  network       = google_compute_network.default.name
  private_ip_google_access = true
}

resource "google_compute_firewall" "http" {
  name          = "http"
  network       = google_compute_network.default.name

  allow {
    protocol    = "tcp"
    ports       = ["30000"]
  }

  source_ranges = ["0.0.0.0/0"]
}
