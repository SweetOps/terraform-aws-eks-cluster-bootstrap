locals {
  linkerd_enabled   = module.this.enabled && contains(var.apps_to_install, "linkerd")
  linkerd           = defaults(var.linkerd, merge(local.helm_default_params, local.linkerd_helm_default_params))
  linkerd_namespace = local.linkerd_enabled ? one(kubernetes_namespace.linkerd[*].metadata.0.name) : ""

  linkerd_helm_default_params = {
    repository      = "https://helm.linkerd.io/stable"
    chart           = "linkerd2"
    version         = "2.10.2"
    override_values = ""
  }

  linkerd_helm_default_values = {
    "fullnameOverride"        = local.linkerd["name"]
    "installNamespace"        = false
    "identityTrustAnchorsPEM" = one(tls_self_signed_cert.linkerd_root_trust_anchor[*].cert_pem)

    "identity" = {
      "issuer" = {
        "scheme" = "kubernetes.io/tls"
      }
    }

    "profileValidator" = {
      "caBundle"       = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
      "externalSecret" = true
    }

    "proxyInjector" = {
      "caBundle"       = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
      "externalSecret" = true
    }
  }
}

data "utils_deep_merge_yaml" "linkerd" {
  count = local.linkerd_enabled ? 1 : 0

  input = [
    yamlencode(local.linkerd_helm_default_values),
    local.linkerd["override_values"]
  ]
}

resource "kubernetes_namespace" "linkerd" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name = local.linkerd["namespace"]

    labels = {
      "linkerd.io/control-plane-ns"          = local.linkerd["namespace"]
      "linkerd.io/is-control-plane"          = "true"
      "config.linkerd.io/admission-webhooks" = "disabled"
    }

    annotations = {
      "linkerd.io/inject" = "disabled"
    }
  }
}

resource "helm_release" "linkerd" {
  count = local.linkerd_enabled ? 1 : 0

  name              = local.linkerd["name"]
  repository        = local.linkerd["repository"]
  chart             = local.linkerd["chart"]
  version           = local.linkerd["version"]
  namespace         = local.linkerd_namespace
  max_history       = local.linkerd["max_history"]
  create_namespace  = local.linkerd["create_namespace"]
  dependency_update = local.linkerd["dependency_update"]
  reuse_values      = local.linkerd["reuse_values"]
  wait              = local.linkerd["wait"]
  timeout           = local.linkerd["timeout"]
  values            = [one(data.utils_deep_merge_yaml.linkerd[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.kube_prometheus_stack,
    kubectl_manifest.linkerd_identity_certificate
  ]
}
