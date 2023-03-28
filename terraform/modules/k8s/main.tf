terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.19.0"
    }
  }
}

provider "kubernetes" {
  host = "https://${var.host}"
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token = var.token
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name = var.app
    labels = {
      app = var.app
    }
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = var.app
      }
    }
    template {
      metadata {
        labels = {
          app = var.app
        }
      }
      spec {
        container {
          image = "${var.artifactory}/${var.app}:${var.commit_sha}"
          name  = var.app
          port{
            container_port = 3000
          }
          resources {
            limits = {
              cpu    = "200m"
              memory = "200Mi"
            }
            requests = {
              cpu    = "10m"
              memory = "64Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 3000
            }
            initial_delay_seconds = 5
            period_seconds = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = var.app
  }
  spec {
    selector = {
      app = var.app
    }
    port {
      node_port = 30000
      port = 3000
      target_port = 3000
    }
    type = "NodePort"
  }
}