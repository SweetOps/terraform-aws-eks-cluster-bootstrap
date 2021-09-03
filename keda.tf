locals {
  keda_enabled = module.this.enabled && contains(var.apps_to_install, "keda")
  keda_helm_default_params = {
    repository      = "https://kedacore.github.io/charts"
    chart           = "keda"
    version         = "2.4.0"
    override_values = ""
  }
  keda_helm_default_values = {
    "fullnameOverride" = "${local.keda["name"]}"
  }
  keda = defaults(var.keda, merge(local.helm_default_params, local.keda_helm_default_params))
}

data "utils_deep_merge_yaml" "keda" {
  count = local.keda_enabled ? 1 : 0

  input = [
    yamlencode(local.keda_helm_default_values),
    local.keda["override_values"]
  ]
}

resource "helm_release" "keda" {
  count = local.keda_enabled ? 1 : 0

  name              = local.keda["name"]
  repository        = local.keda["repository"]
  chart             = local.keda["chart"]
  version           = local.keda["version"]
  namespace         = local.keda["namespace"]
  max_history       = local.keda["max_history"]
  create_namespace  = local.keda["create_namespace"]
  dependency_update = local.keda["dependency_update"]
  reuse_values      = local.keda["reuse_values"]
  wait              = local.keda["wait"]
  timeout           = local.keda["timeout"]
  values            = [one(data.utils_deep_merge_yaml.keda[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
  ]
}
