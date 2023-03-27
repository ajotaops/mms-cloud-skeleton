terraform {
  backend "gcs" {}
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.43.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.58.0"
    }
 }
}

provider "google" {
  region  = var.region
  project = var.project
}

provider "google-beta" {
  region  = var.region
  project = var.project
}

data "google_project" "project" {
}

module "apis" {
  source = "./modules/apis/"
}

module "artifactory"{
  depends_on = [module.apis]
  for_each = toset(["mediamarkt-hackathon"])
  source = "./modules/artifactory"
  name = each.key
  region = var.region
}

module "cb_connection" {
  depends_on = [module.apis]
  source = "./modules/cb_connection/"
  region = var.region
  project_number = data.google_project.project.number
  github_token = var.github_token
  connection_name = var.github_user
  app_id = var.github_app_id
}

module "cb_triggers" {
  for_each = toset(["mms-cloud-skeleton"])
  source = "./modules/cb_triggers/"
  repo_name = each.key
  repo_url = "https://github.com/${var.github_user}/${each.key}.git"
  github_connection = module.cb_connection.connection_name
  region = var.region
  artifactory = "mediamarkt-hackathon"
}
