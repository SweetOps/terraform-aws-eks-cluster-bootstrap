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
    "sentry",
    "loki",
    "tempo",
    "descheduler",
    "vertical_pod_autoscaler",
    "keda",
    "calico",
    "falco",
    "falcosidekick",
    "gatekeeper",
    "github_actions_runners",
    "linkerd"
  ]
  description = "A list of apps which will be installed"
}

variable "eks_cluster_id" {
  type        = string
  description = "EKS cluster ID"
}

variable "sts_regional_endpoints_enabled" {
  type        = bool
  default     = false
  description = "Whether to use STS regional endpoints for service accounts"
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

variable "prometheus_blackbox_exporter" {
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
    name      = "prometheus-blackbox-exporter"
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
    name                 = string
    namespace            = string
    repository           = optional(string)
    chart                = optional(string)
    version              = optional(string)
    override_values      = optional(string)
    max_history          = optional(number)
    create_namespace     = optional(bool)
    dependency_update    = optional(bool)
    reuse_values         = optional(bool)
    wait                 = optional(bool)
    timeout              = optional(number)
    create_aws_resources = optional(bool)
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

variable "loki" {
  type = object(
    {
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
      config = object(
        {
          auth_enabled = optional(bool)

          ingester = object(
            {
              replication_factor   = optional(number)
              max_chunk_age        = optional(string)
              chunk_idle_period    = optional(string)
              chunk_block_size     = optional(number)
              chunk_target_size    = optional(number)
              chunk_encoding       = optional(string)
              chunk_retain_period  = optional(string)
              max_transfer_retries = optional(number)
            }
          )

          limits_config = object(
            {
              ingestion_rate_mb             = optional(number)
              ingestion_burst_size_mb       = optional(number)
              enforce_metric_name           = optional(bool)
              reject_old_samples            = optional(bool)
              reject_old_samples_max_age    = optional(string)
              max_cache_freshness_per_query = optional(string)
              max_concurrent_tail_requests  = optional(number)
            }
          )

          table_manager = object(
            {
              retention_deletes_enabled = optional(bool)
              retention_period          = optional(string)
              creation_grace_period     = optional(string)
              poll_interval             = optional(string)
            }
          )

          query_range = object(
            {
              align_queries_with_step   = optional(bool)
              max_retries               = optional(number)
              split_queries_by_interval = optional(string)
              cache_results             = optional(bool)
            }
          )

          frontend = object(
            {
              log_queries_longer_than    = optional(string)
              compress_responses         = optional(bool)
              max_outstanding_per_tenant = optional(number)
            }
          )

          ruler = object(
            {
              alertmanager_url = optional(string)
              external_url     = optional(string)
            }
          )

          compactor = object(
            {
              compaction_interval           = optional(string)
              retention_enabled             = optional(bool)
              retention_delete_delay        = optional(string)
              retention_delete_worker_count = optional(number)
              delete_request_cancel_period  = optional(string)
              max_compaction_parallelism    = optional(number)
            }
          )
        }
      )
    }
  )

  default = {
    name      = "loki"
    namespace = "logging"
    config = {
      ingester      = {}
      limits_config = {}
      table_manager = {}
      query_range   = {}
      frontend      = {}
      ruler         = {}
      compactor     = {}
    }
  }
}

variable "tempo" {
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
    name      = "tempo"
    namespace = "tracing"
  }
}

variable "linkerd" {
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
    name      = "linkerd"
    namespace = "linkerd"
  }
}

variable "linkerd_viz" {
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
    name      = "linkerd-viz"
    namespace = "linkerd-viz"
  }
}

variable "linkerd_jaeger" {
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
    name      = "linkerd-jaeger"
    namespace = "linkerd-jaeger"
  }
}

variable "linkerd_smi" {
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
    name      = "linkerd-smi"
    namespace = "linkerd-smi"
  }
}

variable "descheduler" {
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
    name      = "descheduler"
    namespace = "kube-system"
  }
}

variable "vertical_pod_autoscaler" {
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
    name      = "vertical-pod-autoscaler"
    namespace = "kube-system"
  }
}

variable "keda" {
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
    name      = "keda"
    namespace = "kube-system"
  }
}

variable "calico" {
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
    name      = "calico"
    namespace = "kube-system"
  }
}

variable "falco" {
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
    name      = "falco"
    namespace = "falco"
  }
}

variable "falcosidekick" {
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
    name      = "falcosidekick"
    namespace = "falco"
  }
}

variable "gatekeeper" {
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
    name      = "gatekeeper"
    namespace = "gatekeeper"
  }
}

variable "github_actions_runners" {
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
    name      = "github-actions-runners"
    namespace = "cicd"
  }
}

variable "postgres_operator" {
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
    name      = "postgres-operator"
    namespace = "infra"
  }
}

variable "postgres_operator_ui" {
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
    name      = "postgres-operator-ui"
    namespace = "infra"
  }
}

variable "prometheus_operator_crd_urls" {
  type        = list(string)
  description = "A list of prometheus-operator urls to CRD manifests for `kubectl apply`. Required for `VictoriaMetrics` provisioning."
  default = [
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.50.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml"
  ]
}

variable "imgproxy" {
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
    name      = "imgproxy"
    namespace = "imgproxy"
  }
}

variable "chartmuseum" {
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
    name      = "chartmuseum"
    namespace = "infra"
  }
}

variable "piggy_webhooks" {
  type = object({
    name                      = string
    namespace                 = string
    repository                = optional(string)
    chart                     = optional(string)
    version                   = optional(string)
    override_values           = optional(string)
    max_history               = optional(number)
    create_namespace          = optional(bool)
    dependency_update         = optional(bool)
    reuse_values              = optional(bool)
    wait                      = optional(bool)
    timeout                   = optional(number)
    create_default_iam_policy = optional(bool)
    create_default_iam_role   = optional(bool)
    iam_policy_document       = optional(string)
  })

  default = {
    name      = "piggy-webhooks"
    namespace = "infra"
  }
}

variable "custom_charts" {
  type = list(object({
    name                = string
    namespace           = string
    repository          = string
    chart               = string
    version             = string
    values              = optional(string)
    repository_username = optional(string)
    repository_password = optional(string)
    max_history         = optional(number)
    create_namespace    = optional(bool)
    dependency_update   = optional(bool)
    reuse_values        = optional(bool)
    wait                = optional(bool)
    timeout             = optional(number)
  }))

  default = []
}
