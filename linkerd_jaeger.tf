locals {
  linkerd_jaeger_enabled   = module.this.enabled && contains(var.apps_to_install, "linkerd_jaeger")
  linkerd_jaeger           = defaults(var.linkerd_jaeger, merge(local.helm_default_params, local.linkerd_jaeger_helm_default_params))
  linkerd_jaeger_namespace = local.linkerd_jaeger_enabled ? one(kubernetes_namespace.linkerd_jaeger[*].metadata.0.name) : ""

  linkerd_jaeger_helm_default_params = {
    repository      = "https://helm.linkerd.io/stable"
    chart           = "linkerd-jaeger"
    version         = "2.10.2"
    override_values = ""
  }

  linkerd_jaeger_helm_default_values = {
    "fullnameOverride" = local.linkerd_jaeger["name"]
    "installNamespace" = false

    "webhook" = {
      "caBundle"       = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
      "externalSecret" = true
    }
  }
}

data "utils_deep_merge_yaml" "linkerd_jaeger" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  input = [
    yamlencode(local.linkerd_jaeger_helm_default_values),
    local.linkerd_jaeger["override_values"]
  ]
}

resource "kubernetes_namespace" "linkerd_jaeger" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  metadata {
    name = local.linkerd_jaeger["namespace"]
  }
}

resource "helm_release" "linkerd_jaeger" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  name              = local.linkerd_jaeger["name"]
  repository        = local.linkerd_jaeger["repository"]
  chart             = local.linkerd_jaeger["chart"]
  version           = local.linkerd_jaeger["version"]
  namespace         = local.linkerd_jaeger_namespace
  max_history       = local.linkerd_jaeger["max_history"]
  create_namespace  = local.linkerd_jaeger["create_namespace"]
  dependency_update = local.linkerd_jaeger["dependency_update"]
  reuse_values      = local.linkerd_jaeger["reuse_values"]
  wait              = local.linkerd_jaeger["wait"]
  timeout           = local.linkerd_jaeger["timeout"]
  values            = [one(data.utils_deep_merge_yaml.linkerd_jaeger[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    kubectl_manifest.linkerd_jaeger_injector_certificate,
  ]
}
