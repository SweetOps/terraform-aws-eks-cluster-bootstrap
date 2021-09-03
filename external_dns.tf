locals {
  external_dns_enabled = module.this.enabled && contains(var.apps_to_install, "external_dns")
  external_dns_helm_default_params = {
    repository      = "https://charts.bitnami.com/bitnami"
    chart           = "external-dns"
    version         = "5.4.4"
    override_values = ""
  }
  external_dns_helm_default_values = {
    "fullnameOverride" = "${local.external_dns["name"]}"
    "txtSuffix"        = "${local.eks_cluster_id}"
  }
  external_dns = defaults(var.external_dns, merge(local.helm_default_params, local.external_dns_helm_default_params))
}

data "utils_deep_merge_yaml" "external_dns" {
  count = local.external_dns_enabled ? 1 : 0

  input = [
    yamlencode(local.external_dns_helm_default_values),
    local.external_dns["override_values"]
  ]
}

resource "helm_release" "external_dns" {
  count = local.external_dns_enabled ? 1 : 0

  name              = local.external_dns["name"]
  repository        = local.external_dns["repository"]
  chart             = local.external_dns["chart"]
  version           = local.external_dns["version"]
  namespace         = local.external_dns["namespace"]
  max_history       = local.external_dns["max_history"]
  create_namespace  = local.external_dns["create_namespace"]
  dependency_update = local.external_dns["dependency_update"]
  reuse_values      = local.external_dns["reuse_values"]
  wait              = local.external_dns["wait"]
  timeout           = local.external_dns["timeout"]
  values            = [one(data.utils_deep_merge_yaml.external_dns[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack
  ]
}
