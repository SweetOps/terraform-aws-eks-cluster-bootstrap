resource "kubernetes_manifest" "linkerd_identity_certificate_ca" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "linkerd-trust-anchor"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "commonName" = "root.${local.linkerd_namespace}.cluster.local"
      "secretName" = "linkerd-trust-anchor"
      "isCA"       = true

      "dnsNames" = [
        "root.${local.linkerd_namespace}.cluster.local",
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

resource "kubernetes_manifest" "linkerd_selfsigned_issuer" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Issuer"

    "metadata" = {
      "name"      = "linkerd-trust-anchor"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "ca" = {
        "secretName" = "linkerd-trust-anchor"
      }
    }
  }

  depends_on = [
    helm_release.cert_manager,
    kubernetes_manifest.linkerd_identity_certificate_ca
  ]
}

resource "kubernetes_manifest" "linkerd_identity_certificate" {
  count = local.linkerd_enabled ? 1 : 0

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "Certificate"

    "metadata" = {
      "name"      = "linkerd-identity-issuer"
      "namespace" = local.linkerd_namespace
    }

    "spec" = {
      "commonName" = "identity.${local.linkerd_namespace}.cluster.local"
      "dnsNames" = [
        "identity.${local.linkerd_namespace}.cluster.local",
      ]

      "duration"    = "48h"
      "renewBefore" = "8h"
      "isCA"        = true
      "secretName"  = "linkerd-identity-issuer"

      "issuerRef" = {
        "kind" = "Issuer"
        "name" = "linkerd-trust-anchor"
      }

      "privateKey" = {
        "algorithm" = "ECDSA"
      }

      "usages" = [
        "cert sign",
        "crl sign",
        "server auth",
        "client auth",
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
    kubernetes_manifest.linkerd_selfsigned_issuer
  ]
}

data "kubernetes_secret" "linkerd_identity_certificate_ca" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name      = "linkerd-trust-anchor"
    namespace = local.linkerd_namespace
  }

  depends_on = [
    kubernetes_manifest.linkerd_identity_certificate_ca
  ]
}
