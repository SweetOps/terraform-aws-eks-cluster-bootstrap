locals {
  postgres_operator_ui_enabled = module.this.enabled && contains(var.apps_to_install, "postgres_operator_ui")
  postgres_operator_ui_helm_default_params = {
    repository      = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
    chart           = "postgres-operator-ui"
    version         = "1.7.0"
    override_values = ""
  }
  postgres_operator_ui_helm_default_values = {
    "fullnameOverride" = local.postgres_operator_ui["name"]
    "envs" = {
      "operatorApiUrl" = "http://${local.postgres_operator["name"]}:8080"
    }
  }
  postgres_operator_ui = defaults(var.postgres_operator_ui, merge(local.helm_default_params, local.postgres_operator_ui_helm_default_params))
}

data "utils_deep_merge_yaml" "postgres_operator_ui" {
  count = local.postgres_operator_ui_enabled ? 1 : 0

  input = [
    yamlencode(local.postgres_operator_ui_helm_default_values),
    local.postgres_operator_ui["override_values"]
  ]
}

resource "helm_release" "postgres_operator_ui" {
  count = local.postgres_operator_ui_enabled ? 1 : 0

  name              = local.postgres_operator_ui["name"]
  repository        = local.postgres_operator_ui["repository"]
  chart             = local.postgres_operator_ui["chart"]
  version           = local.postgres_operator_ui["version"]
  namespace         = local.postgres_operator_ui["namespace"]
  max_history       = local.postgres_operator_ui["max_history"]
  create_namespace  = local.postgres_operator_ui["create_namespace"]
  dependency_update = local.postgres_operator_ui["dependency_update"]
  reuse_values      = local.postgres_operator_ui["reuse_values"]
  wait              = local.postgres_operator_ui["wait"]
  timeout           = local.postgres_operator_ui["timeout"]
  values            = [one(data.utils_deep_merge_yaml.postgres_operator_ui[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
    helm_release.cluster_autoscaler,
    helm_release.postgres_operator_ui
  ]
}
