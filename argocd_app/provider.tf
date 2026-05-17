terraform {
  required_version = ">= 1.6"
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = ">=7.11"
    }
  }
}