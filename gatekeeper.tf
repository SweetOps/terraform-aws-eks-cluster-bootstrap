locals {
  gatekeeper_enabled = module.this.enabled && contains(var.apps_to_install, "gatekeeper")
  gatekeeper_helm_default_params = {
    repository      = "https://open-policy-agent.github.io/gatekeeper/charts"
    chart           = "gatekeeper"
    version         = "3.6.0"
    override_values = ""
  }
  gatekeeper_helm_default_values = {
    "fullnameOverride" = "${local.gatekeeper["name"]}"
  }
  gatekeeper = defaults(var.gatekeeper, merge(local.helm_default_params, local.gatekeeper_helm_default_params))
}

data "utils_deep_merge_yaml" "gatekeeper" {
  count = local.gatekeeper_enabled ? 1 : 0

  input = [
    yamlencode(local.gatekeeper_helm_default_values),
    local.gatekeeper["override_values"]
  ]
}

resource "helm_release" "gatekeeper" {
  count = local.gatekeeper_enabled ? 1 : 0

  name              = local.gatekeeper["name"]
  repository        = local.gatekeeper["repository"]
  chart             = local.gatekeeper["chart"]
  version           = local.gatekeeper["version"]
  namespace         = local.gatekeeper["namespace"]
  max_history       = local.gatekeeper["max_history"]
  create_namespace  = local.gatekeeper["create_namespace"]
  dependency_update = local.gatekeeper["dependency_update"]
  reuse_values      = local.gatekeeper["reuse_values"]
  wait              = local.gatekeeper["wait"]
  timeout           = local.gatekeeper["timeout"]
  values            = [one(data.utils_deep_merge_yaml.gatekeeper[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cluster_autoscaler,
    kubectl_manifest.prometheus_operator_crds
  ]
}
