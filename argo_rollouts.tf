locals {
  argo_rollouts_enabled = module.this.enabled && contains(var.apps_to_install, "argo_rollouts")
  argo_rollouts_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argo-rollouts"
    version         = "2.0.1"
    override_values = ""
  }
  argo_rollouts_helm_default_values = {
    "fullnameOverride" = "${local.argo_rollouts["name"]}"
  }
  argo_rollouts = defaults(var.argo_rollouts, merge(local.helm_default_params, local.argo_rollouts_helm_default_params))
}

data "utils_deep_merge_yaml" "argo_rollouts" {
  count = local.argo_rollouts_enabled ? 1 : 0

  input = [
    yamlencode(local.argo_rollouts_helm_default_values),
    local.argo_rollouts["override_values"]
  ]
}

resource "helm_release" "argo_rollouts" {
  count = local.argo_rollouts_enabled ? 1 : 0

  name              = local.argo_rollouts["name"]
  repository        = local.argo_rollouts["repository"]
  chart             = local.argo_rollouts["chart"]
  version           = local.argo_rollouts["version"]
  namespace         = local.argo_rollouts["namespace"]
  max_history       = local.argo_rollouts["max_history"]
  create_namespace  = local.argo_rollouts["create_namespace"]
  dependency_update = local.argo_rollouts["dependency_update"]
  reuse_values      = local.argo_rollouts["reuse_values"]
  wait              = local.argo_rollouts["wait"]
  timeout           = local.argo_rollouts["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argo_rollouts[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns,
    helm_release.ingress_nginx
  ]
}
