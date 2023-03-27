resource "google_cloudbuildv2_repository" "repository" {
  provider = google-beta
  name = var.repo_name
  location = var.region
  parent_connection = var.github_connection
  remote_uri = var.repo_url
}

resource "google_cloudbuild_trigger" "trigger" {
  provider = google-beta
  location = var.region
  name = var.repo_name
  repository_event_config {
    repository = google_cloudbuildv2_repository.repository.id
    push {
      branch = "main"
    }
  }
  substitutions = {
    _ARTIFACTORY_NAME = var.artifactory
  }
  ignored_files = ["terraform/"]
  filename = "cloudbuild.yaml"
}