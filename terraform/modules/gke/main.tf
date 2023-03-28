resource "google_container_cluster" "gke" {
  name = "${var.name}-gke"
  location = var.zone
  remove_default_node_pool = true
  initial_node_count = 1
  network = var.network
  subnetwork = var.subnetwork
}

data "google_client_config" "current" {}

resource "google_container_node_pool" "pool" {
  name       = "${var.name}-pool"
  location   = "${var.zone}"
  cluster    = google_container_cluster.gke.name
  node_count = 2

  node_config {
    machine_type = var.gke_node_machine
    disk_size_gb = var.gke_disk
    image_type   = var.gke_so
  }
}
