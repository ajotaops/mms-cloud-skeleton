resource "google_artifact_registry_repository" "repository" {
  location      = var.region
  repository_id = var.name
  format        = "DOCKER"
}