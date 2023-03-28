output "network" {
  value = google_compute_network.default.name
}

output "subnetwork" {
  value = {
    for k, subnetwork in google_compute_subnetwork.default : k => subnetwork.name
  }
}