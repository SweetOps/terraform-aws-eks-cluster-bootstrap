locals {
  argo_events_enabled = module.this.enabled && contains(var.apps_to_install, "argo_events")
  argo_events_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argo-events"
    version         = "1.7.0"
    override_values = ""
  }
  argo_events_helm_default_values = {
    "fullnameOverride" = "${local.argo_events["name"]}"
  }
  argo_events = defaults(var.argo_events, merge(local.helm_default_params, local.argo_events_helm_default_params))
}

data "utils_deep_merge_yaml" "argo_events" {
  count = local.argo_events_enabled ? 1 : 0

  input = [
    yamlencode(local.argo_events_helm_default_values),
    local.argo_events["override_values"]
  ]
}

resource "helm_release" "argo_events" {
  count = local.argo_events_enabled ? 1 : 0

  name              = local.argo_events["name"]
  repository        = local.argo_events["repository"]
  chart             = local.argo_events["chart"]
  version           = local.argo_events["version"]
  namespace         = local.argo_events["namespace"]
  max_history       = local.argo_events["max_history"]
  create_namespace  = local.argo_events["create_namespace"]
  dependency_update = local.argo_events["dependency_update"]
  reuse_values      = local.argo_events["reuse_values"]
  wait              = local.argo_events["wait"]
  timeout           = local.argo_events["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argo_events[*].output)]

  depends_on = [
    local.default_depends_on
  ]
}
