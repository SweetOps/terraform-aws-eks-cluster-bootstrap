locals {
  aws_node_termination_handler_enabled = module.this.enabled && contains(var.apps_to_install, "aws_node_termination_handler")
  aws_node_termination_handler         = defaults(var.aws_node_termination_handler, local.helm_default_params)
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
  values            = local.aws_node_termination_handler["values"]

  set {
    name  = "fullnameOverride"
    value = local.aws_node_termination_handler["name"]
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
