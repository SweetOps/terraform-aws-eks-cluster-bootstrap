locals {
  node_local_dns_enabled = module.this.enabled && contains(var.apps_to_install, "node_local_dns")
}

resource "helm_release" "node_local_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  name              = var.node_local_dns["name"]
  repository        = var.node_local_dns["repository"]
  chart             = var.node_local_dns["chart"]
  version           = var.node_local_dns["version"]
  namespace         = var.node_local_dns["namespace"]
  max_history       = var.node_local_dns["max_history"]
  create_namespace  = var.node_local_dns["create_namespace"]
  dependency_update = var.node_local_dns["dependency_update"]
  values            = var.node_local_dns["values"]

  set {
    name  = "fullnameOverride"
    value = var.node_local_dns["name"]
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
