resource "google_project_service" "api_cloudbuild" {
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "google_project_service" "api_secretmanager" {
  service = "secretmanager.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "google_project_service" "api_artifactregistry" {
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "google_project_service" "api_compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "google_project_service" "api_container" {
  service = "container.googleapis.com"
  disable_on_destroy = false

  provisioner "local-exec" {
    command = "sleep 10"
  }
}