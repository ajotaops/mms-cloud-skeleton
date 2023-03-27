resource "google_secret_manager_secret" "github_token" {
  secret_id = "github-${var.connection_name}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "github_token_version" {
  secret = google_secret_manager_secret.github_token.id
  secret_data = var.github_token
}

data "google_iam_policy" "secret" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
      ]
  }
}

resource "google_secret_manager_secret_iam_policy" "github_token" {
  secret_id = google_secret_manager_secret.github_token.secret_id
  policy_data = data.google_iam_policy.secret.policy_data
}

resource "google_cloudbuildv2_connection" "github" {
  provider = google-beta
  name = var.connection_name
  location = var.region
  github_config {
    app_installation_id = var.app_id
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.github_token_version.id
    }
  }
}

