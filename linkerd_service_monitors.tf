# taken from: https://github.com/kinvolk/lokomotive/blob/master/assets/charts/components/linkerd2/templates/service-monitors.yaml
resource "kubectl_manifest" "linkerd_web_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-web
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: web
  endpoints:
  - targetPort: 9994
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_sp_validator_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-sp-validator
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: sp-validator
  endpoints:
  - targetPort: 9997
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_controller_api_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-controller-api
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: controller
  endpoints:
  - targetPort: 9995
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_identity_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-identity
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: identity
  endpoints:
  - targetPort: 9990
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_proxy_injector_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-proxy-injector
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: proxy-injector
  endpoints:
  - targetPort: 9995
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_tap_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-tap
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: tap
  endpoints:
  - targetPort: 9998
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_dst_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-dst
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-component: destination
  endpoints:
  - targetPort: 9996
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_component
      - __meta_kubernetes_pod_container_port_name
      action: keep
      regex: (.*);admin-http$
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      action: replace
      targetLabel: component
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}

resource "kubectl_manifest" "linkerd_proxies_service_monitor" {
  count = local.linkerd_enabled ? 1 : 0

  wait = true

  yaml_body = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    app: linkerd
    release: prometheus-operator
  name: linkerd-proxies
  namespace: ${local.linkerd_namespace}
spec:
  selector:
    matchLabels:
      linkerd.io/control-plane-ns: linkerd
  endpoints:
  - targetPort: 4191
    relabelings:
    - sourceLabels:
      - __meta_kubernetes_pod_container_name
      - __meta_kubernetes_pod_container_port_name
      - __meta_kubernetes_pod_label_linkerd_io_control_plane_ns
      action: keep
      regex: ^linkerd-proxy;linkerd-admin;{{.Values.namespace}}$
    - sourceLabels: [__meta_kubernetes_namespace]
      action: replace
      targetLabel: namespace
    - sourceLabels: [__meta_kubernetes_pod_name]
      action: replace
      targetLabel: pod
    - sourceLabels: [__meta_kubernetes_pod_label_linkerd_io_proxy_job]
      action: replace
      targetLabel: k8s_job
    - action: labeldrop
      regex: __meta_kubernetes_pod_label_linkerd_io_proxy_job
    - action: labelmap
      regex: __meta_kubernetes_pod_label_linkerd_io_proxy_(.+)
    - action: labeldrop
      regex: __meta_kubernetes_pod_label_linkerd_io_proxy_(.+)
    - action: labelmap
      regex: __meta_kubernetes_pod_label_linkerd_io_(.+)
    - action: labelmap
      regex: __meta_kubernetes_pod_label_(.+)
      replacement: __tmp_pod_label_$1
    - action: labelmap
      regex: __tmp_pod_label_linkerd_io_(.+)
      replacement:  __tmp_pod_label_$1
    - action: labeldrop
      regex: __tmp_pod_label_linkerd_io_(.+)
    - action: labelmap
      regex: __tmp_pod_label_(.+)
YAML

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}
