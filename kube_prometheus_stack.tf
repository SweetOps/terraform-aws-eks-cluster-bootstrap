locals {
  kube_prometheus_stack_enabled = module.this.enabled && contains(var.apps_to_install, "kube_prometheus_stack")
  kube_prometheus_stack_helm_default_params = {
    repository      = "https://prometheus-community.github.io/helm-charts"
    chart           = "kube-prometheus-stack"
    version         = "19.0.2"
    override_values = ""
  }
  kube_prometheus_stack_helm_default_values = {
    "fullnameOverride" = "${local.kube_prometheus_stack["name"]}"
  }
  kube_prometheus_stack = defaults(var.kube_prometheus_stack, merge(local.helm_default_params, local.kube_prometheus_stack_helm_default_params))
}

data "utils_deep_merge_yaml" "kube_prometheus_stack" {
  count = local.kube_prometheus_stack_enabled ? 1 : 0

  input = [
    yamlencode(local.kube_prometheus_stack_helm_default_values),
    local.kube_prometheus_stack["override_values"]
  ]
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
  values            = [one(data.utils_deep_merge_yaml.kube_prometheus_stack[*].output)]

  depends_on = [
    helm_release.calico
  ]
}
