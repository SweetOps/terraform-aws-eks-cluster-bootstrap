locals {
  kube_prometheus_stack_enabled = module.this.enabled && contains(var.apps_to_install, "kube_prometheus_stack")
}

resource "helm_release" "kube_prometheus_stack" {
  count = local.kube_prometheus_stack_enabled ? 1 : 0

  name              = var.kube_prometheus_stack["name"]
  repository        = var.kube_prometheus_stack["repository"]
  chart             = var.kube_prometheus_stack["chart"]
  version           = var.kube_prometheus_stack["version"]
  namespace         = var.kube_prometheus_stack["namespace"]
  max_history       = var.kube_prometheus_stack["max_history"]
  create_namespace  = var.kube_prometheus_stack["create_namespace"]
  dependency_update = var.kube_prometheus_stack["dependency_update"]
  values            = var.kube_prometheus_stack["values"]

  set {
    name  = "fullnameOverride"
    value = var.kube_prometheus_stack["name"]
  }
}
