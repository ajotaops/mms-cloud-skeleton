#Global project GCP
variable "project" {}
variable "region" {}
variable "zone" {}

#VPC
variable "vpcs" {}

#Github
variable "github_token" {sensitive = true}
variable "github_user" {}
variable "github_app_id" {}
variable "github_repos" {}

#GKE
variable "gke_disk" {}
variable "gke_so" {}
variable "gke_node_machine" {}
