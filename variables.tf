variable "apps_to_install" {
  type = list(string)
  default = [
    "cert_manager",
    "cert_manager_issuers",
    "cluster_autoscaler",
    "victoria_metrics",
    "ebs_csi_driver",
    "node_local_dns",
    "kube_prometheus_stack",
    "aws_node_termination_handler",
    "external_dns",
    "ingress_nginx",
    "vault",
    "actions_runner_controller",
    "velero",
    "oauth2_proxy",
    "node_problem_detector",
    "argo_events",
    "argo_rollouts",
    "argo_workflows",
    "argocd",
    "argocd_applicationset",
    "argocd_image_updater",
    "argocd_notifications",
    "sentry"
  ]
  description = "A list of apps which will be installed"
}

variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID"
}

variable "cert_manager" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "cert-manager"
    namespace = "cert-manager"
  }
}

variable "cert_manager_issuers" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "cert-manager-issuers"
    namespace = "cert-manager"
  }
}

variable "victoria_metrics" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "monitoring"
    namespace = "monitoring"
  }
}

variable "cluster_autoscaler" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }
}

variable "ebs_csi_driver" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "ebs-csi-driver"
    namespace = "kube-system"
  }
}

variable "node_local_dns" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "node-local-dns"
    namespace = "kube-system"
  }
}

variable "kube_prometheus_stack" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "kube-prometheus-stack"
    namespace = "monitoring"
  }
}

variable "aws_node_termination_handler" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "aws-node-termination-handler"
    namespace = "kube-system"
  }
}

variable "external_dns" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "external-dns"
    namespace = "infra"
  }
}

variable "ingress_nginx" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "ingress-nginx"
    namespace = "infra"
  }
}

variable "oauth2_proxy" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "oauth2-proxy"
    namespace = "infra"
  }
}

variable "actions_runner_controller" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "actions-runner-controller"
    namespace = "cicd"
  }
}

variable "velero" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "velero"
    namespace = "velero"
  }
}

variable "vault" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "vault"
    namespace = "vault"
  }
}

variable "node_problem_detector" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "node-problem-detector"
    namespace = "monitoring"
  }
}

variable "argocd_notifications" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argocd-notifications"
    namespace = "argo"
  }
}

variable "argocd_image_updater" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argocd-image-updater"
    namespace = "argo"
  }
}

variable "argocd_applicationset" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argocd-applicationset"
    namespace = "argo"
  }
}

variable "argo_workflows" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argo-workflows"
    namespace = "argo"
  }
}

variable "argo_rollouts" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argo-rollouts"
    namespace = "argo"
  }
}

variable "argo_events" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argo-events"
    namespace = "argo"
  }
}

variable "argocd" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "argocd"
    namespace = "argo"
  }
}

variable "sentry" {
  type = object({
    name              = string
    namespace         = string
    repository        = optional(string)
    chart             = optional(string)
    version           = optional(string)
    override_values   = optional(string)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    name      = "sentry"
    namespace = "sentry"
  }
}
