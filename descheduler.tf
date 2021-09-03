locals {
  descheduler_enabled = module.this.enabled && contains(var.apps_to_install, "descheduler")
  descheduler_helm_default_params = {
    repository      = "https://kubernetes-sigs.github.io/descheduler/"
    chart           = "descheduler"
    version         = "0.21.0"
    override_values = ""
  }
  descheduler_helm_default_values = {
    "fullnameOverride" = "${local.descheduler["name"]}"
  }
  descheduler = defaults(var.descheduler, merge(local.helm_default_params, local.descheduler_helm_default_params))
}

data "utils_deep_merge_yaml" "descheduler" {
  count = local.descheduler_enabled ? 1 : 0

  input = [
    yamlencode(local.descheduler_helm_default_values),
    local.descheduler["override_values"]
  ]
}

resource "helm_release" "descheduler" {
  count = local.descheduler_enabled ? 1 : 0

  name              = local.descheduler["name"]
  repository        = local.descheduler["repository"]
  chart             = local.descheduler["chart"]
  version           = local.descheduler["version"]
  namespace         = local.descheduler["namespace"]
  max_history       = local.descheduler["max_history"]
  create_namespace  = local.descheduler["create_namespace"]
  dependency_update = local.descheduler["dependency_update"]
  reuse_values      = local.descheduler["reuse_values"]
  wait              = local.descheduler["wait"]
  timeout           = local.descheduler["timeout"]
  values            = [one(data.utils_deep_merge_yaml.descheduler[*].output)]

  depends_on = [
    helm_release.node_local_dns,
  ]
}
