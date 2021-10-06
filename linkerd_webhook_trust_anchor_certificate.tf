resource "tls_private_key" "linkerd_webhook_trust_anchor" {
  count = local.linkerd_enabled ? 1 : 0

  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "linkerd_webhook_trust_anchor" {
  count = local.linkerd_enabled ? 1 : 0

  key_algorithm         = one(tls_private_key.linkerd_webhook_trust_anchor[*].algorithm)
  private_key_pem       = one(tls_private_key.linkerd_webhook_trust_anchor[*].private_key_pem)
  validity_period_hours = 87600
  early_renewal_hours   = 80000
  is_ca_certificate     = true

  subject {
    common_name = "webhook.linkerd.cluster.local"
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
    "server_auth",
    "client_auth"
  ]
}

resource "kubernetes_secret" "linkerd_webhook_trust_anchor" {
  count = local.linkerd_enabled ? 1 : 0

  metadata {
    name      = "webhook-issuer-tls"
    namespace = local.linkerd_namespace
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = one(tls_self_signed_cert.linkerd_webhook_trust_anchor[*].cert_pem)
    "tls.key" = one(tls_private_key.linkerd_webhook_trust_anchor[*].private_key_pem)
  }

  depends_on = [
    helm_release.cert_manager
  ]
}
