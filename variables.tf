variable "apps_to_install" {
  type        = list(string)
  default     = ["cert_manager", "cluster_autoscaler", "victoria_metrics"]
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
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "cert-manager"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "cert-manager"
    namespace         = "cert-manager"
    repository        = "https://charts.jetstack.io"
    values            = []
    version           = "1.5.0"
  }
}

variable "victoria_metrics" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "victoria-metrics-k8s-stack"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "monitoring"
    namespace         = "monitoring"
    repository        = "https://victoriametrics.github.io/helm-charts"
    values            = []
    version           = "1.5.0"
  }
}

variable "cluster_autoscaler" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "cluster-autoscaler"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "cluster-autoscaler"
    namespace         = "kube-system"
    repository        = "https://kubernetes.github.io/autoscaler"
    values            = []
    version           = "9.7.0"
  }
}

variable "ebs_csi_driver" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "ebs-csi-driver"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "ebs-csi-driver"
    namespace         = "kube-system"
    repository        = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    values            = []
    version           = "2.1.0"
  }
}

variable "node_local_dns" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "node-local-dns"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "node-local-dns"
    namespace         = "kube-system"
    repository        = "https://lablabs.github.io/k8s-nodelocaldns-helm/"
    values            = []
    version           = "1.3.2"
  }
}

variable "kube_prometheus_stack" {
  type = object({
    name              = string
    repository        = string
    chart             = string
    version           = string
    namespace         = string
    max_history       = number
    create_namespace  = bool
    dependency_update = bool
    values            = list(any)
  })
  default = {
    chart             = "kube-prometheus-stack"
    create_namespace  = true
    dependency_update = true
    max_history       = 10
    name              = "kube-prometheus-stack"
    namespace         = "monitoring"
    repository        = "https://prometheus-community.github.io/helm-charts"
    values            = []
    version           = "17.2.2"
  }
}
