locals {
  imgproxy_enabled = module.this.enabled && contains(var.apps_to_install, "imgproxy")
  imgproxy_helm_default_params = {
    repository      = "https://helm.imgproxy.net/"
    chart           = "imgproxy"
    version         = "0.8.4"
    override_values = ""
  }
  imgproxy_helm_default_values = {
    "fullnameOverride" = "${local.imgproxy["name"]}"
  }
  imgproxy = defaults(var.imgproxy, merge(local.helm_default_params, local.imgproxy_helm_default_params))
}

data "utils_deep_merge_yaml" "imgproxy" {
  count = local.imgproxy_enabled ? 1 : 0

  input = [
    yamlencode(local.imgproxy_helm_default_values),
    local.imgproxy["override_values"]
  ]
}

resource "helm_release" "imgproxy" {
  count = local.imgproxy_enabled ? 1 : 0

  name              = local.imgproxy["name"]
  repository        = local.imgproxy["repository"]
  chart             = local.imgproxy["chart"]
  version           = local.imgproxy["version"]
  namespace         = local.imgproxy["namespace"]
  max_history       = local.imgproxy["max_history"]
  create_namespace  = local.imgproxy["create_namespace"]
  dependency_update = local.imgproxy["dependency_update"]
  reuse_values      = local.imgproxy["reuse_values"]
  wait              = local.imgproxy["wait"]
  timeout           = local.imgproxy["timeout"]
  values            = [one(data.utils_deep_merge_yaml.imgproxy[*].output)]

  depends_on = [
    local.default_depends_on
  ]
}
