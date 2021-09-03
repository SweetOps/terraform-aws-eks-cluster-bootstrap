locals {
  argocd_image_updater_enabled = module.this.enabled && contains(var.apps_to_install, "argocd_image_updater")
  argocd_image_updater_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argocd-image-updater"
    version         = "0.1.0"
    override_values = ""
  }
  argocd_image_updater_helm_default_values = {
    "fullnameOverride" = "${local.argocd_image_updater["name"]}"
  }
  argocd_image_updater = defaults(var.argocd_image_updater, merge(local.helm_default_params, local.argocd_image_updater_helm_default_params))
}

data "utils_deep_merge_yaml" "argocd_image_updater" {
  count = local.argocd_image_updater_enabled ? 1 : 0

  input = [
    yamlencode(local.argocd_image_updater_helm_default_values),
    local.argocd_image_updater["override_values"]
  ]
}

resource "helm_release" "argocd_image_updater" {
  count = local.argocd_image_updater_enabled ? 1 : 0

  name              = local.argocd_image_updater["name"]
  repository        = local.argocd_image_updater["repository"]
  chart             = local.argocd_image_updater["chart"]
  version           = local.argocd_image_updater["version"]
  namespace         = local.argocd_image_updater["namespace"]
  max_history       = local.argocd_image_updater["max_history"]
  create_namespace  = local.argocd_image_updater["create_namespace"]
  dependency_update = local.argocd_image_updater["dependency_update"]
  reuse_values      = local.argocd_image_updater["reuse_values"]
  wait              = local.argocd_image_updater["wait"]
  timeout           = local.argocd_image_updater["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argocd_image_updater[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns,
    helm_release.argocd
  ]
}
