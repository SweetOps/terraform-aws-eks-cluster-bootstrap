locals {
  aws_node_termination_handler_enabled = module.this.enabled && contains(var.apps_to_install, "aws_node_termination_handler")
  aws_node_termination_handler = defaults(var.aws_node_termination_handler, {
    max_history       = 10
    create_namespace  = true
    dependency_update = true
    reuse_values      = true
    timeout           = 300
  })
}

resource "helm_release" "aws_node_termination_handler" {
  count = local.aws_node_termination_handler_enabled ? 1 : 0

  name              = var.aws_node_termination_handler["name"]
  repository        = var.aws_node_termination_handler["repository"]
  chart             = var.aws_node_termination_handler["chart"]
  version           = var.aws_node_termination_handler["version"]
  namespace         = var.aws_node_termination_handler["namespace"]
  max_history       = var.aws_node_termination_handler["max_history"]
  create_namespace  = var.aws_node_termination_handler["create_namespace"]
  dependency_update = var.aws_node_termination_handler["dependency_update"]
  values            = var.aws_node_termination_handler["values"]

  set {
    name  = "fullnameOverride"
    value = var.aws_node_termination_handler["name"]
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}
