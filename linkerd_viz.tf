locals {
  linkerd_viz_enabled   = module.this.enabled && contains(var.apps_to_install, "linkerd_viz")
  linkerd_viz           = defaults(var.linkerd_viz, merge(local.helm_default_params, local.linkerd_viz_helm_default_params))
  linkerd_viz_namespace = local.linkerd_viz_enabled ? one(kubernetes_namespace.linkerd_viz[*].metadata.0.name) : ""

  linkerd_viz_helm_default_params = {
    repository      = "https://helm.linkerd.io/stable"
    chart           = "linkerd-viz"
    version         = "2.11.0"
    override_values = ""
  }

  linkerd_viz_helm_default_values = {
    "fullnameOverride" = local.linkerd_viz["name"]
    "installNamespace" = false

    "tap" = {
      "caBundle"       = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
      "externalSecret" = true
    }

    "tapInjector" = {
      "caBundle"       = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
      "externalSecret" = true
    }
  }
}

data "utils_deep_merge_yaml" "linkerd_viz" {
  count = local.linkerd_viz_enabled ? 1 : 0

  input = [
    yamlencode(local.linkerd_viz_helm_default_values),
    local.linkerd_viz["override_values"]
  ]
}

resource "kubernetes_namespace" "linkerd_viz" {
  count = local.linkerd_viz_enabled ? 1 : 0

  metadata {
    name = local.linkerd_viz["namespace"]
  }
}

resource "helm_release" "linkerd_viz" {
  count = local.linkerd_viz_enabled ? 1 : 0

  name              = local.linkerd_viz["name"]
  repository        = local.linkerd_viz["repository"]
  chart             = local.linkerd_viz["chart"]
  version           = local.linkerd_viz["version"]
  namespace         = local.linkerd_viz_namespace
  max_history       = local.linkerd_viz["max_history"]
  create_namespace  = local.linkerd_viz["create_namespace"]
  dependency_update = local.linkerd_viz["dependency_update"]
  reuse_values      = local.linkerd_viz["reuse_values"]
  wait              = local.linkerd_viz["wait"]
  timeout           = local.linkerd_viz["timeout"]
  values            = [one(data.utils_deep_merge_yaml.linkerd_viz[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    kubectl_manifest.linkerd_viz_tap_certificate,
    kubectl_manifest.linkerd_viz_tap_injector_certificate,
    helm_release.linkerd,
    kubectl_manifest.prometheus_operator_crds
  ]
}
