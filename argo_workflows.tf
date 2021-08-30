locals {
  argo_workflows_enabled = module.this.enabled && contains(var.apps_to_install, "argo_workflows")
  argo_workflows_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argo-workflows"
    version         = "0.5.0"
    override_values = ""
  }
  argo_workflows_helm_default_values = {
    "fullnameOverride" = "${local.argo_workflows["name"]}"
  }
  argo_workflows = defaults(var.argo_workflows, merge(local.helm_default_params, local.argo_workflows_helm_default_params))
}

data "utils_deep_merge_yaml" "argo_workflows" {
  count = local.argo_workflows_enabled ? 1 : 0

  input = [
    yamlencode(local.argo_workflows_helm_default_values),
    local.argo_workflows["override_values"]
  ]
}

resource "helm_release" "argo_workflows" {
  count = local.argo_workflows_enabled ? 1 : 0

  name              = local.argo_workflows["name"]
  repository        = local.argo_workflows["repository"]
  chart             = local.argo_workflows["chart"]
  version           = local.argo_workflows["version"]
  namespace         = local.argo_workflows["namespace"]
  max_history       = local.argo_workflows["max_history"]
  create_namespace  = local.argo_workflows["create_namespace"]
  dependency_update = local.argo_workflows["dependency_update"]
  reuse_values      = local.argo_workflows["reuse_values"]
  wait              = local.argo_workflows["wait"]
  timeout           = local.argo_workflows["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argo_workflows[*].output)]

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns
  ]
}
