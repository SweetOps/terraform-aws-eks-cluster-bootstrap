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
    "ingress_nginx"
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
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "cert-manager"
    name       = "cert-manager"
    namespace  = "cert-manager"
    repository = "https://charts.jetstack.io"
    values     = []
    version    = "1.5.0"
  }
}

variable "cert_manager_issuers" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "cert-manager-issuers"
    name       = "cert-manager-issuers"
    namespace  = "cert-manager"
    repository = "https://charts.adfinis.com"
    values     = []
    version    = "0.2.2"
  }
}

variable "victoria_metrics" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "victoria-metrics-k8s-stack"
    name       = "monitoring"
    namespace  = "monitoring"
    repository = "https://victoriametrics.github.io/helm-charts"
    values     = []
    version    = "1.5.0"
  }
}

variable "cluster_autoscaler" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "cluster-autoscaler"
    name       = "cluster-autoscaler"
    namespace  = "kube-system"
    repository = "https://kubernetes.github.io/autoscaler"
    values     = []
    version    = "9.7.0"
  }
}

variable "ebs_csi_driver" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "ebs-csi-driver"
    name       = "ebs-csi"
    namespace  = "kube-system"
    repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    values     = []
    version    = "2.1.0"
  }
}

variable "node_local_dns" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "node-local-dns"
    name       = "node-local-dns"
    namespace  = "kube-system"
    repository = "https://lablabs.github.io/k8s-nodelocaldns-helm/"
    values     = []
    version    = "1.3.2"
  }
}

variable "kube_prometheus_stack" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "kube-prometheus-stack"
    name       = "kube-prometheus-stack"
    namespace  = "monitoring"
    repository = "https://prometheus-community.github.io/helm-charts"
    values     = []
    version    = "17.2.2"
  }
}

variable "aws_node_termination_handler" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "aws-node-termination-handler"
    name       = "aws-node-termination-handler"
    namespace  = "kube-system"
    repository = "https://aws.github.io/eks-charts"
    values     = []
    version    = "0.15.2"
  }
}

variable "external_dns" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "external-dns"
    name       = "external-dns"
    namespace  = "infra"
    repository = "https://charts.bitnami.com/bitnami"
    values     = []
    version    = "1.1.2"
  }
}

variable "ingress_nginx" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    values            = list(any)
    max_history       = optional(number)
    create_namespace  = optional(bool)
    dependency_update = optional(bool)
    reuse_values      = optional(bool)
    wait              = optional(bool)
    timeout           = optional(number)
  })

  default = {
    chart      = "ingress-nginx"
    name       = "ingress-nginx"
    namespace  = "infra"
    repository = "https://kubernetes.github.io/ingress-nginx"
    values     = []
    version    = "3.35.0"
  }
}
