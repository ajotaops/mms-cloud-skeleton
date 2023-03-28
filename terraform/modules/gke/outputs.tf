output "token" {
  value     = data.google_client_config.current.access_token
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.gke.master_auth.0.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value     = google_container_cluster.gke.endpoint
  sensitive = true
}