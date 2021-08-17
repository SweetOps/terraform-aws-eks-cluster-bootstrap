locals {
  ingress_nginx_enabled = module.this.enabled && contains(var.apps_to_install, "ingress_nginx")
}

resource "helm_release" "ingress_nginx" {
  count = local.ingress_nginx_enabled ? 1 : 0

  name              = var.ingress_nginx["name"]
  repository        = var.ingress_nginx["repository"]
  chart             = var.ingress_nginx["chart"]
  version           = var.ingress_nginx["version"]
  namespace         = var.ingress_nginx["namespace"]
  max_history       = var.ingress_nginx["max_history"]
  create_namespace  = var.ingress_nginx["create_namespace"]
  dependency_update = var.ingress_nginx["dependency_update"]
  values            = var.ingress_nginx["values"]

  set {
    name  = "fullnameOverride"
    value = var.ingress_nginx["name"]
  }

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.kube_prometheus_stack
  ]
}
