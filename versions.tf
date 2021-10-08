terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.14.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.11"
    }
  }
}
