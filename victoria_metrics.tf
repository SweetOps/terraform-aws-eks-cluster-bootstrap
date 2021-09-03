locals {
  victoria_metrics_enabled = module.this.enabled && contains(var.apps_to_install, "victoria_metrics")
  victoria_metrics         = defaults(var.victoria_metrics, merge(local.helm_default_params, local.victoria_metrics_helm_default_params))
  victoria_metrics_helm_default_params = {
    repository      = "https://victoriametrics.github.io/helm-charts"
    chart           = "victoria-metrics-k8s-stack"
    version         = "0.4.1"
    override_values = ""
  }
  victoria_metrics_helm_default_values = {
    "fullnameOverride" = "${local.victoria_metrics["name"]}"
  }
}

data "utils_deep_merge_yaml" "victoria_metrics" {
  count = local.victoria_metrics_enabled ? 1 : 0

  input = [
    yamlencode(local.victoria_metrics_helm_default_values),
    local.victoria_metrics["override_values"]
  ]
}

resource "helm_release" "victoria_metrics" {
  count = local.victoria_metrics_enabled ? 1 : 0

  name              = local.victoria_metrics["name"]
  repository        = local.victoria_metrics["repository"]
  chart             = local.victoria_metrics["chart"]
  version           = local.victoria_metrics["version"]
  namespace         = local.victoria_metrics["namespace"]
  max_history       = local.victoria_metrics["max_history"]
  create_namespace  = local.victoria_metrics["create_namespace"]
  dependency_update = local.victoria_metrics["dependency_update"]
  reuse_values      = local.victoria_metrics["reuse_values"]
  wait              = local.victoria_metrics["wait"]
  timeout           = local.victoria_metrics["timeout"]
  values            = [one(data.utils_deep_merge_yaml.victoria_metrics[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    helm_release.ebs_csi_driver,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.ingress_nginx,
    helm_release.node_local_dns
  ]
}
