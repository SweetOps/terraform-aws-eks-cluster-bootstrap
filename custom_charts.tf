locals {
  custom_charts_helm_default_params = {
    max_history         = 10
    create_namespace    = true
    dependency_update   = true
    wait                = true
    reuse_values        = false
    timeout             = 300
    repository_username = ""
    repository_password = ""
  }
}

resource "helm_release" "custom_charts" {
  for_each = { for chart in var.custom_charts :
    format("%s-%s-%s", chart.name, chart.namespace, chart.chart) => defaults(chart, local.custom_charts_helm_default_params)
  }

  name                = each.value.name
  repository          = each.value.repository
  chart               = each.value.chart
  version             = each.value.version
  namespace           = each.value.namespace
  max_history         = each.value.max_history
  create_namespace    = each.value.create_namespace
  dependency_update   = each.value.dependency_update
  reuse_values        = each.value.reuse_values
  wait                = each.value.wait
  timeout             = each.value.timeout
  repository_username = each.value.repository_username
  repository_password = each.value.repository_password
  values              = [each.value.values]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds,
    helm_release.cluster_autoscaler
  ]
}
