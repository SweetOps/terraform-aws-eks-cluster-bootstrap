locals {
  postgres_operator_enabled = module.this.enabled && contains(var.apps_to_install, "postgres_operator")
  postgres_operator_helm_default_params = {
    repository      = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
    chart           = "postgres-operator"
    version         = "1.7.0"
    override_values = ""
  }
  postgres_operator_helm_default_values = {
    "fullnameOverride" = "${local.postgres_operator["name"]}"
  }
  postgres_operator = defaults(var.postgres_operator, merge(local.helm_default_params, local.postgres_operator_helm_default_params))
}

data "utils_deep_merge_yaml" "postgres_operator" {
  count = local.postgres_operator_enabled ? 1 : 0

  input = [
    yamlencode(local.postgres_operator_helm_default_values),
    local.postgres_operator["override_values"]
  ]
}

resource "helm_release" "postgres_operator" {
  count = local.postgres_operator_enabled ? 1 : 0

  name              = local.postgres_operator["name"]
  repository        = local.postgres_operator["repository"]
  chart             = local.postgres_operator["chart"]
  version           = local.postgres_operator["version"]
  namespace         = local.postgres_operator["namespace"]
  max_history       = local.postgres_operator["max_history"]
  create_namespace  = local.postgres_operator["create_namespace"]
  dependency_update = local.postgres_operator["dependency_update"]
  reuse_values      = local.postgres_operator["reuse_values"]
  wait              = local.postgres_operator["wait"]
  timeout           = local.postgres_operator["timeout"]
  values            = [one(data.utils_deep_merge_yaml.postgres_operator[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
    helm_release.cluster_autoscaler
  ]
}
