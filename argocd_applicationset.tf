locals {
  argocd_applicationset_enabled = module.this.enabled && contains(var.apps_to_install, "argocd_applicationset")
  argocd_applicationset_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argocd-applicationset"
    version         = "1.4.0"
    override_values = ""
  }
  argocd_applicationset_helm_default_values = {
    "fullnameOverride" = "${local.argocd_applicationset["name"]}"
  }
  argocd_applicationset = defaults(var.argocd_applicationset, merge(local.helm_default_params, local.argocd_applicationset_helm_default_params))
}

data "utils_deep_merge_yaml" "argocd_applicationset" {
  count = local.argocd_applicationset_enabled ? 1 : 0

  input = [
    yamlencode(local.argocd_applicationset_helm_default_values),
    local.argocd_applicationset["override_values"]
  ]
}

resource "helm_release" "argocd_applicationset" {
  count = local.argocd_applicationset_enabled ? 1 : 0

  name              = local.argocd_applicationset["name"]
  repository        = local.argocd_applicationset["repository"]
  chart             = local.argocd_applicationset["chart"]
  version           = local.argocd_applicationset["version"]
  namespace         = local.argocd_applicationset["namespace"]
  max_history       = local.argocd_applicationset["max_history"]
  create_namespace  = local.argocd_applicationset["create_namespace"]
  dependency_update = local.argocd_applicationset["dependency_update"]
  reuse_values      = local.argocd_applicationset["reuse_values"]
  wait              = local.argocd_applicationset["wait"]
  timeout           = local.argocd_applicationset["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argocd_applicationset[*].output)]

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns,
    helm_release.argocd
  ]
}
