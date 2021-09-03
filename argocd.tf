locals {
  argocd_enabled = module.this.enabled && contains(var.apps_to_install, "argocd")
  argocd_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argo-cd"
    version         = "3.17.5"
    override_values = ""
  }
  argocd_helm_default_values = {
    "fullnameOverride" = "${local.argocd["name"]}"
  }
  argocd = defaults(var.argocd, merge(local.helm_default_params, local.argocd_helm_default_params))
}

data "utils_deep_merge_yaml" "argocd" {
  count = local.argocd_enabled ? 1 : 0

  input = [
    yamlencode(local.argocd_helm_default_values),
    local.argocd["override_values"]
  ]
}

resource "helm_release" "argocd" {
  count = local.argocd_enabled ? 1 : 0

  name              = local.argocd["name"]
  repository        = local.argocd["repository"]
  chart             = local.argocd["chart"]
  version           = local.argocd["version"]
  namespace         = local.argocd["namespace"]
  max_history       = local.argocd["max_history"]
  create_namespace  = local.argocd["create_namespace"]
  dependency_update = local.argocd["dependency_update"]
  reuse_values      = local.argocd["reuse_values"]
  wait              = local.argocd["wait"]
  timeout           = local.argocd["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argocd[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns,
    helm_release.ingress_nginx
  ]
}
