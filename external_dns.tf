locals {
  external_dns_enabled = module.this.enabled && contains(var.apps_to_install, "external_dns")
}

resource "helm_release" "external_dns" {
  count = local.external_dns_enabled ? 1 : 0

  name              = var.external_dns["name"]
  repository        = var.external_dns["repository"]
  chart             = var.external_dns["chart"]
  version           = var.external_dns["version"]
  namespace         = var.external_dns["namespace"]
  max_history       = var.external_dns["max_history"]
  create_namespace  = var.external_dns["create_namespace"]
  dependency_update = var.external_dns["dependency_update"]
  values            = var.external_dns["values"]

  set {
    name  = "fullnameOverride"
    value = var.external_dns["name"]
  }

  set {
    name  = "txtSuffix"
    value = one(data.aws_eks_cluster.default[*].id)
  }

  depends_on = [
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack
  ]
}
