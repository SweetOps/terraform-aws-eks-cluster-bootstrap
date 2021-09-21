resource "kubectl_manifest" "linkerd_viz_webhook_trust_anchor_issuer" {
  count = local.linkerd_viz_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: webhook-issuer
  namespace: ${local.linkerd_viz_namespace}
spec:
  ca:
    secretName: ${one(kubernetes_secret.linkerd_webhook_trust_anchor[*].metadata.0.name)}
YAML
}

resource "kubectl_manifest" "linkerd_viz_tap_certificate" {
  count = local.linkerd_viz_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: tap
  namespace: ${local.linkerd_viz_namespace}
spec:
  secretName: tap-k8s-tls
  duration: 24h
  renewBefore: 1h
  issuerRef:
    name: ${one(kubectl_manifest.linkerd_webhook_trust_anchor_issuer[*].name)}
    kind: Issuer
  commonName: tap.linkerd-viz.svc
  dnsNames:
  - tap.linkerd-viz.svc
  isCA: false
  privateKey:
    algorithm: ECDSA
  usages:
  - server auth
YAML
}

resource "kubectl_manifest" "linkerd_viz_tap_injector_certificate" {
  count = local.linkerd_viz_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: linkerd-tap-injector
  namespace: ${local.linkerd_viz_namespace}
spec:
  secretName: tap-injector-k8s-tls
  duration: 24h
  renewBefore: 1h
  issuerRef:
    name: ${one(kubectl_manifest.linkerd_webhook_trust_anchor_issuer[*].name)}
    kind: Issuer
  commonName: tap-injector.linkerd-viz.svc
  dnsNames:
  - tap-injector.linkerd-viz.svc
  isCA: false
  privateKey:
    algorithm: ECDSA
  usages:
  - server auth
YAML
}
