locals {
  kube_prometheus_stack_enabled = module.this.enabled && contains(var.apps_to_install, "kube_prometheus_stack")
  kube_prometheus_stack         = defaults(var.kube_prometheus_stack, local.helm_default_params)
}

resource "helm_release" "kube_prometheus_stack" {
  count = local.kube_prometheus_stack_enabled ? 1 : 0

  name              = local.kube_prometheus_stack["name"]
  repository        = local.kube_prometheus_stack["repository"]
  chart             = local.kube_prometheus_stack["chart"]
  version           = local.kube_prometheus_stack["version"]
  namespace         = local.kube_prometheus_stack["namespace"]
  max_history       = local.kube_prometheus_stack["max_history"]
  create_namespace  = local.kube_prometheus_stack["create_namespace"]
  dependency_update = local.kube_prometheus_stack["dependency_update"]
  reuse_values      = local.kube_prometheus_stack["reuse_values"]
  wait              = local.kube_prometheus_stack["wait"]
  timeout           = local.kube_prometheus_stack["timeout"]
  values            = local.kube_prometheus_stack["values"]

  set {
    name  = "fullnameOverride"
    value = local.kube_prometheus_stack["name"]
  }
}
