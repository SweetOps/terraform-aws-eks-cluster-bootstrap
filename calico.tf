locals {
  calico_enabled = module.this.enabled && contains(var.apps_to_install, "calico")
  calico_helm_default_params = {
    repository      = "https://aws.github.io/eks-charts"
    chart           = "aws-calico"
    version         = "0.3.8"
    override_values = ""
  }
  calico_helm_default_values = {
    "fullnameOverride" = "${local.calico["name"]}"
  }
  calico = defaults(var.calico, merge(local.helm_default_params, local.calico_helm_default_params))
}

data "utils_deep_merge_yaml" "calico" {
  count = local.calico_enabled ? 1 : 0

  input = [
    yamlencode(local.calico_helm_default_values),
    local.calico["override_values"]
  ]
}

resource "helm_release" "calico" {
  count = local.calico_enabled ? 1 : 0

  name              = local.calico["name"]
  repository        = local.calico["repository"]
  chart             = local.calico["chart"]
  version           = local.calico["version"]
  namespace         = local.calico["namespace"]
  max_history       = local.calico["max_history"]
  create_namespace  = local.calico["create_namespace"]
  dependency_update = local.calico["dependency_update"]
  reuse_values      = local.calico["reuse_values"]
  wait              = local.calico["wait"]
  timeout           = local.calico["timeout"]
  values            = [one(data.utils_deep_merge_yaml.calico[*].output)]

  depends_on = [
    kubectl_manifest.prometheus_operator_crds
  ]
}
