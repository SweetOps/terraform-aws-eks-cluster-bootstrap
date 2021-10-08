locals {
  sentry_enabled = module.this.enabled && contains(var.apps_to_install, "sentry")
  sentry_helm_default_params = {
    repository      = "https://sentry-kubernetes.github.io/charts"
    chart           = "sentry"
    version         = "11.6.0"
    override_values = ""
  }
  sentry_helm_default_values = {
    "fullnameOverride" = "${local.sentry["name"]}"
  }
  sentry = defaults(var.sentry, merge(local.helm_default_params, local.sentry_helm_default_params))
}

data "utils_deep_merge_yaml" "sentry" {
  count = local.sentry_enabled ? 1 : 0

  input = [
    yamlencode(local.sentry_helm_default_values),
    local.sentry["override_values"]
  ]
}

resource "helm_release" "sentry" {
  count = local.sentry_enabled ? 1 : 0

  name              = local.sentry["name"]
  repository        = local.sentry["repository"]
  chart             = local.sentry["chart"]
  version           = local.sentry["version"]
  namespace         = local.sentry["namespace"]
  max_history       = local.sentry["max_history"]
  create_namespace  = local.sentry["create_namespace"]
  dependency_update = local.sentry["dependency_update"]
  reuse_values      = local.sentry["reuse_values"]
  wait              = local.sentry["wait"]
  timeout           = local.sentry["timeout"]
  values            = [one(data.utils_deep_merge_yaml.sentry[*].output)]

  depends_on = [
    local.default_depends_on
  ]
}
