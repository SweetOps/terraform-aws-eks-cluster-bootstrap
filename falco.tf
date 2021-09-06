locals {
  falco_enabled = module.this.enabled && contains(var.apps_to_install, "falco")
  falco_helm_default_params = {
    repository      = "https://falcosecurity.github.io/charts"
    chart           = "falco"
    version         = "1.15.7"
    override_values = ""
  }
  falco_helm_default_values = {
    "fullnameOverride" = "${local.falco["name"]}"
  }
  falco = defaults(var.falco, merge(local.helm_default_params, local.falco_helm_default_params))
}

data "utils_deep_merge_yaml" "falco" {
  count = local.falco_enabled ? 1 : 0

  input = [
    yamlencode(local.falco_helm_default_values),
    local.falco["override_values"]
  ]
}

resource "helm_release" "falco" {
  count = local.falco_enabled ? 1 : 0

  name              = local.falco["name"]
  repository        = local.falco["repository"]
  chart             = local.falco["chart"]
  version           = local.falco["version"]
  namespace         = local.falco["namespace"]
  max_history       = local.falco["max_history"]
  create_namespace  = local.falco["create_namespace"]
  dependency_update = local.falco["dependency_update"]
  reuse_values      = local.falco["reuse_values"]
  wait              = local.falco["wait"]
  timeout           = local.falco["timeout"]
  values            = [one(data.utils_deep_merge_yaml.falco[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
  ]
}
