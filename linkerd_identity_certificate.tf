resource "kubectl_manifest" "linkerd_root_trust_anchor_issuer" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: linkerd-trust-anchor
  namespace: ${local.linkerd_namespace}
spec:
  ca:
    secretName: ${one(kubernetes_secret.linkerd_root_trust_anchor[*].metadata.0.name)}
YAML
}

resource "kubectl_manifest" "linkerd_identity_certificate" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: linkerd-identity-issuer
  namespace: ${local.linkerd_namespace}
spec:
  secretName: linkerd-identity-issuer
  duration: 48h
  renewBefore: 12h
  issuerRef:
    name: ${one(kubectl_manifest.linkerd_root_trust_anchor_issuer[*].name)}
    kind: Issuer
  commonName: identity.linkerd.cluster.local
  dnsNames:
  - identity.linkerd.cluster.local
  isCA: true
  privateKey:
    algorithm: ECDSA
  usages:
  - cert sign
  - crl sign
  - server auth
  - client auth
YAML
}
