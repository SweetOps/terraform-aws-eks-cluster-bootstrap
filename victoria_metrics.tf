locals {
  victoria_metrics_enabled = module.this.enabled && contains(var.apps_to_install, "victoria_metrics")
}

resource "helm_release" "victoria_metrics" {
  count = local.victoria_metrics_enabled ? 1 : 0

  name              = var.victoria_metrics["name"]
  repository        = var.victoria_metrics["repository"]
  chart             = var.victoria_metrics["chart"]
  version           = var.victoria_metrics["version"]
  namespace         = var.victoria_metrics["namespace"]
  max_history       = var.victoria_metrics["max_history"]
  create_namespace  = var.victoria_metrics["create_namespace"]
  dependency_update = var.victoria_metrics["dependency_update"]
  values            = var.victoria_metrics["values"]

  set {
    name  = "fullnameOverride"
    value = var.victoria_metrics["name"]
  }

  # depends_on = [
  #   helm_release.victoria_metrics
  # ]
}
