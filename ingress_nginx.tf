locals {
  ingress_nginx_enabled = module.this.enabled && contains(var.apps_to_install, "ingress_nginx")
  ingress_nginx         = defaults(var.ingress_nginx, local.helm_default_params)
}

resource "helm_release" "ingress_nginx" {
  count = local.ingress_nginx_enabled ? 1 : 0

  name              = local.ingress_nginx["name"]
  repository        = local.ingress_nginx["repository"]
  chart             = local.ingress_nginx["chart"]
  version           = local.ingress_nginx["version"]
  namespace         = local.ingress_nginx["namespace"]
  max_history       = local.ingress_nginx["max_history"]
  create_namespace  = local.ingress_nginx["create_namespace"]
  dependency_update = local.ingress_nginx["dependency_update"]
  reuse_values      = local.ingress_nginx["reuse_values"]
  wait              = local.ingress_nginx["wait"]
  timeout           = local.ingress_nginx["timeout"]
  values            = local.ingress_nginx["values"]

  set {
    name  = "fullnameOverride"
    value = local.ingress_nginx["name"]
  }

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.kube_prometheus_stack
  ]
}
