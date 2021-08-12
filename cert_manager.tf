locals {
  cert_manager_enabled = module.this.enabled && contains(var.apps_to_install, "cert-manager")
}

resource "helm_release" "cert_manager" {
  count = local.cert_manager_enabled ? 1 : 0

  name              = var.cert_manager["name"]
  repository        = var.cert_manager["repository"]
  chart             = var.cert_manager["chart"]
  version           = var.cert_manager["version"]
  namespace         = var.cert_manager["namespace"]
  max_history       = var.cert_manager["max_history"]
  create_namespace  = var.cert_manager["create_namespace"]
  dependency_update = var.cert_manager["dependency_update"]
  values            = var.cert_manager["values"]

  set {
    name  = "fullnameOverride"
    value = var.cert_manager["name"]
  }

  depends_on = [
    helm_release.victoria_metrics
  ]
}
