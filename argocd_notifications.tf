locals {
  argocd_notifications_enabled = module.this.enabled && contains(var.apps_to_install, "argocd_notifications")
  argocd_notifications_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argocd-notifications"
    version         = "1.5.0"
    override_values = ""
  }
  argocd_notifications_helm_default_values = {
    "fullnameOverride" = "${local.argocd_notifications["name"]}"
  }
  argocd_notifications = defaults(var.argocd_notifications, merge(local.helm_default_params, local.argocd_notifications_helm_default_params))
}

data "utils_deep_merge_yaml" "argocd_notifications" {
  count = local.argocd_notifications_enabled ? 1 : 0

  input = [
    yamlencode(local.argocd_notifications_helm_default_values),
    local.argocd_notifications["override_values"]
  ]
}

resource "helm_release" "argocd_notifications" {
  count = local.argocd_notifications_enabled ? 1 : 0

  name              = local.argocd_notifications["name"]
  repository        = local.argocd_notifications["repository"]
  chart             = local.argocd_notifications["chart"]
  version           = local.argocd_notifications["version"]
  namespace         = local.argocd_notifications["namespace"]
  max_history       = local.argocd_notifications["max_history"]
  create_namespace  = local.argocd_notifications["create_namespace"]
  dependency_update = local.argocd_notifications["dependency_update"]
  reuse_values      = local.argocd_notifications["reuse_values"]
  wait              = local.argocd_notifications["wait"]
  timeout           = local.argocd_notifications["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argocd_notifications[*].output)]

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.external_dns,
    helm_release.argocd
  ]
}
