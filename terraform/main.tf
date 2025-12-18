terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev-env"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod-env"
  }
}

resource "kubernetes_resource_quota" "dev_quota" {
  metadata {
    name      = "dev-quota"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    hard = {
      "pods" = "10"             # Max 10 podów w środowisku dev
      "requests.cpu" = "1"      # Max 1 rdzeń procesora łącznie
      "requests.memory" = "1Gi" # Max 1GB RAM łącznie
    }
  }
}
