resource "kubernetes_manifest" "linkerd_webhook_certificate_ca" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "webhook-issuer-tls"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "commonName" = "webhook.${local.linkerd_namespace}.cluster.local"
      "secretName" = "webhook-issuer-tls"
      "isCA"       = true

      "dnsNames" = [
        "webhook.${local.linkerd_namespace}.cluster.local",
      ]

      "issuerRef" = {
        "kind"  = "ClusterIssuer"
        "name"  = "selfsigned-issuer"
        "group" = "cert-manager.io"
      }

      "privateKey" = {
        "algorithm" = "ECDSA"
      }
    }
  }

  wait_for = {
    fields = {
      "status.conditions.status" = "True"
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "30s"
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_manifest.linkerd_selfsigned_cluster_issuer
  ]
}

resource "kubernetes_manifest" "linkerd_webhook_selfsigned_issuer" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"

    "metadata" = {
      "name"      = "webhook-issuer"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "ca" = {
        "secretName" = "webhook-issuer-tls"
      }
    }
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_manifest.linkerd_webhook_certificate_ca
  ]
}

resource "kubernetes_manifest" "linkerd_proxy_injector_certificate" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "linkerd-proxy-injector"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "commonName" = "linkerd-proxy-injector.${local.linkerd_namespace}.svc"
      "dnsNames" = [
        "linkerd-proxy-injector.${local.linkerd_namespace}.svc",
      ]

      "duration"    = "48h"
      "renewBefore" = "8h"
      "isCA"        = false
      "secretName"  = "linkerd-proxy-injector-k8s-tls"

      "issuerRef" = {
        "kind" = "Issuer"
        "name" = "webhook-issuer"
      }

      "privateKey" = {
        "algorithm" = "ECDSA"
      }

      "usages" = [
        "server auth"
      ]
    }
  }

  wait_for = {
    fields = {
      "status.conditions.status" = "True"
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "30s"
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_manifest.linkerd_webhook_selfsigned_issuer
  ]
}

resource "kubernetes_manifest" "linkerd_sp_validator_certificate" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "linkerd-sp-validator"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "commonName" = "linkerd-sp-validator.${local.linkerd_namespace}.svc"
      "dnsNames" = [
        "linkerd-sp-validator.${local.linkerd_namespace}.svc",
      ]

      "duration"    = "48h"
      "renewBefore" = "8h"
      "isCA"        = false
      "secretName"  = "linkerd-sp-validator-k8s-tls"

      "issuerRef" = {
        "kind" = "Issuer"
        "name" = "webhook-issuer"
      }

      "privateKey" = {
        "algorithm" = "ECDSA"
      }

      "usages" = [
        "server auth"
      ]
    }
  }

  wait_for = {
    fields = {
      "status.conditions.status" = "True"
    }
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "30s"
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_manifest.linkerd_webhook_selfsigned_issuer
  ]
}

data "kubernetes_secret" "linkerd_webhook_certificate_ca" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name      = "webhook-issuer-tls"
    namespace = local.linkerd_namespace
  }

  depends_on = [
    kubernetes_manifest.linkerd_webhook_certificate_ca
  ]
}
