locals {
  aws_node_termination_handler_enabled = module.this.enabled && contains(var.apps_to_install, "aws_node_termination_handler")
  aws_node_termination_handler         = defaults(var.aws_node_termination_handler, merge(local.helm_default_params, local.aws_node_termination_handler_helm_default_params))
  aws_node_termination_handler_helm_default_params = {
    repository      = "https://aws.github.io/eks-charts"
    version         = "0.15.2"
    chart           = "aws-node-termination-handler"
    override_values = ""
  }
  aws_node_termination_handler_helm_default_values = {
    "fullnameOverride"           = "${local.aws_node_termination_handler["name"]}"
    "enablePrometheusServer"     = false
    "host_networking"            = true
    "nodeTerminationGracePeriod" = 240
    "podMonitor" = {
      "create" = false
    }
    "podTerminationGracePeriod" = 60
    "taintNode"                 = true
  }
}

data "utils_deep_merge_yaml" "aws_node_termination_handler" {
  count = local.aws_node_termination_handler_enabled ? 1 : 0

  input = [
    yamlencode(local.aws_node_termination_handler_helm_default_values),
    local.aws_node_termination_handler["override_values"]
  ]
}

resource "helm_release" "aws_node_termination_handler" {
  count = local.aws_node_termination_handler_enabled ? 1 : 0

  name              = local.aws_node_termination_handler["name"]
  repository        = local.aws_node_termination_handler["repository"]
  chart             = local.aws_node_termination_handler["chart"]
  version           = local.aws_node_termination_handler["version"]
  namespace         = local.aws_node_termination_handler["namespace"]
  max_history       = local.aws_node_termination_handler["max_history"]
  create_namespace  = local.aws_node_termination_handler["create_namespace"]
  dependency_update = local.aws_node_termination_handler["dependency_update"]
  reuse_values      = local.aws_node_termination_handler["reuse_values"]
  wait              = local.aws_node_termination_handler["wait"]
  timeout           = local.aws_node_termination_handler["timeout"]
  values            = [one(data.utils_deep_merge_yaml.aws_node_termination_handler[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    kubectl_manifest.prometheus_operator_crds
  ]
}
