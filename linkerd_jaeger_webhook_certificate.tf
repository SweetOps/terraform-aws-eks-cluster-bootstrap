resource "kubectl_manifest" "linkerd_jaeger_webhook_trust_anchor_issuer" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: webhook-issuer
  namespace: ${local.linkerd_jaeger_namespace}
spec:
  ca:
    secretName: ${one(kubernetes_secret.linkerd_webhook_trust_anchor[*].metadata.0.name)}
YAML
}

resource "kubectl_manifest" "linkerd_jaeger_injector_certificate" {
  count = local.linkerd_jaeger_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: jaeger-injector
  namespace: ${local.linkerd_jaeger_namespace}
spec:
  secretName: jaeger-injector-k8s-tls
  duration: 24h
  renewBefore: 1h
  issuerRef:
    name: ${one(kubectl_manifest.linkerd_webhook_trust_anchor_issuer[*].name)}
    kind: Issuer
  commonName: jaeger-injector.linkerd.svc
  dnsNames:
  - jaeger-injector.linkerd.svc
  isCA: false
  privateKey:
    algorithm: ECDSA
  usages:
  - server auth
YAML
}
