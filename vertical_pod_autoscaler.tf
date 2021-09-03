locals {
  vertical_pod_autoscaler_enabled = module.this.enabled && contains(var.apps_to_install, "vertical_pod_autoscaler")
  vertical_pod_autoscaler_helm_default_params = {
    repository      = "https://cowboysysop.github.io/charts/"
    chart           = "vertical-pod-autoscaler"
    version         = "3.5.0"
    override_values = ""
  }
  vertical_pod_autoscaler_helm_default_values = {
    "fullnameOverride" = "${local.vertical_pod_autoscaler["name"]}"
  }
  vertical_pod_autoscaler = defaults(var.vertical_pod_autoscaler, merge(local.helm_default_params, local.vertical_pod_autoscaler_helm_default_params))
}

data "utils_deep_merge_yaml" "vertical_pod_autoscaler" {
  count = local.vertical_pod_autoscaler_enabled ? 1 : 0

  input = [
    yamlencode(local.vertical_pod_autoscaler_helm_default_values),
    local.vertical_pod_autoscaler["override_values"]
  ]
}

resource "helm_release" "vertical_pod_autoscaler" {
  count = local.vertical_pod_autoscaler_enabled ? 1 : 0

  name              = local.vertical_pod_autoscaler["name"]
  repository        = local.vertical_pod_autoscaler["repository"]
  chart             = local.vertical_pod_autoscaler["chart"]
  version           = local.vertical_pod_autoscaler["version"]
  namespace         = local.vertical_pod_autoscaler["namespace"]
  max_history       = local.vertical_pod_autoscaler["max_history"]
  create_namespace  = local.vertical_pod_autoscaler["create_namespace"]
  dependency_update = local.vertical_pod_autoscaler["dependency_update"]
  reuse_values      = local.vertical_pod_autoscaler["reuse_values"]
  wait              = local.vertical_pod_autoscaler["wait"]
  timeout           = local.vertical_pod_autoscaler["timeout"]
  values            = [one(data.utils_deep_merge_yaml.vertical_pod_autoscaler[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
  ]
}
