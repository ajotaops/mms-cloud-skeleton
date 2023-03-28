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
  zone = var.zone
}

provider "google-beta" {
  region  = var.region
  project = var.project
  zone = var.zone
}

data "google_project" "project" {
}

module "apis" {
  source = "./modules/apis/"
}

module "artifactory"{
  depends_on = [module.apis]
  source = "./modules/artifactory"
  name = var.project
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
  for_each = toset(var.github_repos)
  source = "./modules/cb_triggers/"
  repo_name = each.key
  repo_url = "https://github.com/${var.github_user}/${each.key}.git"
  github_connection = module.cb_connection.connection_name
  region = var.region
  artifactory = module.artifactory.artifactory
}

module "vpc"{
  depends_on = [module.apis]
  source = "./modules/vpc/"
  vpcs = var.vpcs 
  name = var.project
}

module "gke"{
  depends_on = [module.apis]
  source = "./modules/gke"
  zone = var.zone
  name = var.project
  network = module.vpc.network
  subnetwork = module.vpc.subnetwork[var.region]
  gke_disk = var.gke_disk
  gke_so = var.gke_so
  gke_node_machine = var.gke_node_machine
}

module "k8s-app" {
  source = "./modules/k8s"
  host = module.gke.host
  token = module.gke.token
  cluster_ca_certificate = module.gke.cluster_ca_certificate
  artifactory = "${var.region}-docker.pkg.dev/${var.project}/${module.artifactory.artifactory}"
  app = "mms-cloud-skeleton"
  commit_sha = ""
}