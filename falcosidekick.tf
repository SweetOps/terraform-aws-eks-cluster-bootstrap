locals {
  falcosidekick_enabled = module.this.enabled && contains(var.apps_to_install, "falcosidekick")
  falcosidekick_helm_default_params = {
    repository      = "https://falcosidekicksecurity.github.io/charts"
    chart           = "falcosidekick"
    version         = "0.3.17"
    override_values = ""
  }
  falcosidekick_helm_default_values = {
    "fullnameOverride" = "${local.falcosidekick["name"]}"
  }
  falcosidekick = defaults(var.falcosidekick, merge(local.helm_default_params, local.falcosidekick_helm_default_params))
}

data "utils_deep_merge_yaml" "falcosidekick" {
  count = local.falcosidekick_enabled ? 1 : 0

  input = [
    yamlencode(local.falcosidekick_helm_default_values),
    local.falcosidekick["override_values"]
  ]
}

resource "helm_release" "falcosidekick" {
  count = local.falcosidekick_enabled ? 1 : 0

  name              = local.falcosidekick["name"]
  repository        = local.falcosidekick["repository"]
  chart             = local.falcosidekick["chart"]
  version           = local.falcosidekick["version"]
  namespace         = local.falcosidekick["namespace"]
  max_history       = local.falcosidekick["max_history"]
  create_namespace  = local.falcosidekick["create_namespace"]
  dependency_update = local.falcosidekick["dependency_update"]
  reuse_values      = local.falcosidekick["reuse_values"]
  wait              = local.falcosidekick["wait"]
  timeout           = local.falcosidekick["timeout"]
  values            = [one(data.utils_deep_merge_yaml.falcosidekick[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
  ]
}
