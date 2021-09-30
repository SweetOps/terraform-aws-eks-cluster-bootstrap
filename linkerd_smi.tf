locals {
  linkerd_smi_enabled   = module.this.enabled && contains(var.apps_to_install, "linkerd_smi")
  linkerd_smi           = defaults(var.linkerd_smi, merge(local.helm_default_params, local.linkerd_smi_helm_default_params))
  linkerd_smi_namespace = local.linkerd_smi_enabled ? one(kubernetes_namespace.linkerd_smi[*].metadata.0.name) : ""

  linkerd_smi_helm_default_params = {
    repository      = "https://linkerd.github.io/linkerd-smi"
    chart           = "linkerd-smi"
    version         = "0.1.0"
    override_values = ""
  }
  linkerd_smi_helm_default_values = {
    "fullnameOverride" = "${local.linkerd_smi["name"]}"
    "installNamespace" = false
    "namespace"        = local.linkerd_smi_namespace
  }
}

data "utils_deep_merge_yaml" "linkerd_smi" {
  count = local.linkerd_smi_enabled ? 1 : 0

  input = [
    yamlencode(local.linkerd_smi_helm_default_values),
    local.linkerd_smi["override_values"]
  ]
}


resource "kubernetes_namespace" "linkerd_smi" {
  count = local.linkerd_smi_enabled ? 1 : 0

  metadata {
    name = local.linkerd_smi["namespace"]

    labels = {
      "linkerd.io/extension" = "smi"
    }

    annotations = {
      "linkerd.io/inject" = "enabled"
    }
  }
}

resource "helm_release" "linkerd_smi" {
  count = local.linkerd_smi_enabled ? 1 : 0

  name              = local.linkerd_smi["name"]
  repository        = local.linkerd_smi["repository"]
  chart             = local.linkerd_smi["chart"]
  version           = local.linkerd_smi["version"]
  namespace         = local.linkerd_smi_namespace
  max_history       = local.linkerd_smi["max_history"]
  create_namespace  = local.linkerd_smi["create_namespace"]
  dependency_update = local.linkerd_smi["dependency_update"]
  reuse_values      = local.linkerd_smi["reuse_values"]
  wait              = local.linkerd_smi["wait"]
  timeout           = local.linkerd_smi["timeout"]
  values            = [one(data.utils_deep_merge_yaml.linkerd_smi[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack
  ]
}
