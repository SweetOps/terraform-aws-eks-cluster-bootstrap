locals {
  cert_manager_enabled = module.this.enabled && contains(var.apps_to_install, "cert_manager")
  cert_manager         = defaults(var.cert_manager, local.helm_default_params)

}

resource "helm_release" "cert_manager" {
  count = local.cert_manager_enabled ? 1 : 0

  name              = local.cert_manager["name"]
  repository        = local.cert_manager["repository"]
  chart             = local.cert_manager["chart"]
  version           = local.cert_manager["version"]
  namespace         = local.cert_manager["namespace"]
  max_history       = local.cert_manager["max_history"]
  create_namespace  = local.cert_manager["create_namespace"]
  dependency_update = local.cert_manager["dependency_update"]
  reuse_values      = local.cert_manager["reuse_values"]
  wait              = local.cert_manager["wait"]
  timeout           = local.cert_manager["timeout"]
  values            = local.cert_manager["values"]

  set {
    name  = "fullnameOverride"
    value = local.cert_manager["name"]
  }

  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns
  ]
}
