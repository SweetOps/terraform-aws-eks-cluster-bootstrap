locals {
  prometheus_blackbox_exporter_enabled = module.this.enabled && contains(var.apps_to_install, "prometheus_blackbox_exporter")
  prometheus_blackbox_exporter_helm_default_params = {
    repository      = "https://prometheus-community.github.io/helm-charts"
    chart           = "prometheus-blackbox-exporter"
    version         = "5.0.3"
    override_values = ""
  }
  prometheus_blackbox_exporter_helm_default_values = {
    "fullnameOverride" = "${local.prometheus_blackbox_exporter["name"]}"
  }
  prometheus_blackbox_exporter = defaults(var.prometheus_blackbox_exporter, merge(local.helm_default_params, local.prometheus_blackbox_exporter_helm_default_params))
}

data "utils_deep_merge_yaml" "prometheus_blackbox_exporter" {
  count = local.prometheus_blackbox_exporter_enabled ? 1 : 0

  input = [
    yamlencode(local.prometheus_blackbox_exporter_helm_default_values),
    local.prometheus_blackbox_exporter["override_values"]
  ]
}

resource "helm_release" "prometheus_blackbox_exporter" {
  count = local.prometheus_blackbox_exporter_enabled ? 1 : 0

  name              = local.prometheus_blackbox_exporter["name"]
  repository        = local.prometheus_blackbox_exporter["repository"]
  chart             = local.prometheus_blackbox_exporter["chart"]
  version           = local.prometheus_blackbox_exporter["version"]
  namespace         = local.prometheus_blackbox_exporter["namespace"]
  max_history       = local.prometheus_blackbox_exporter["max_history"]
  create_namespace  = local.prometheus_blackbox_exporter["create_namespace"]
  dependency_update = local.prometheus_blackbox_exporter["dependency_update"]
  reuse_values      = local.prometheus_blackbox_exporter["reuse_values"]
  wait              = local.prometheus_blackbox_exporter["wait"]
  timeout           = local.prometheus_blackbox_exporter["timeout"]
  values            = [one(data.utils_deep_merge_yaml.prometheus_blackbox_exporter[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
    helm_release.cluster_autoscaler,
    kubectl_manifest.prometheus_operator_crds
  ]
}
