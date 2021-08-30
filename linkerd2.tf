locals {
  linkerd2_enabled = module.this.enabled && contains(var.apps_to_install, "linkerd2")
  linkerd2_helm_default_params = {
    repository      = "https://helm.linkerd.io/stable"
    chart           = "linkerd2"
    version         = "2.10.2"
    override_values = ""
  }
  linkerd2_helm_default_values = {
    "fullnameOverride" = "${local.linkerd2["name"]}"
  }
  linkerd2 = defaults(var.linkerd2, merge(local.helm_default_params, local.linkerd2_helm_default_params))
}

data "utils_deep_merge_yaml" "linkerd2" {
  count = local.linkerd2_enabled ? 1 : 0

  input = [
    yamlencode(local.linkerd2_helm_default_values),
    local.linkerd2["override_values"]
  ]
}

resource "helm_release" "linkerd2" {
  count = local.linkerd2_enabled ? 1 : 0

  name              = local.linkerd2["name"]
  repository        = local.linkerd2["repository"]
  chart             = local.linkerd2["chart"]
  version           = local.linkerd2["version"]
  namespace         = local.linkerd2["namespace"]
  max_history       = local.linkerd2["max_history"]
  create_namespace  = local.linkerd2["create_namespace"]
  dependency_update = local.linkerd2["dependency_update"]
  reuse_values      = local.linkerd2["reuse_values"]
  wait              = local.linkerd2["wait"]
  timeout           = local.linkerd2["timeout"]
  values            = [one(data.utils_deep_merge_yaml.linkerd2[*].output)]

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    helm_release.ingress_nginx
  ]
}
