locals {
  loki_enabled = module.this.enabled && contains(var.apps_to_install, "loki")
  loki_helm_default_params = {
    repository      = "https://grafana.github.io/helm-charts"
    chart           = "loki-distributed"
    version         = "0.39.3"
    override_values = ""

    config = {
      auth_enabled = true

      ingester = {
        replication_factor   = 1
        max_chunk_age        = "1h"
        chunk_idle_period    = "1h"
        chunk_block_size     = 262144
        chunk_target_size    = 1536000
        chunk_encoding       = "snappy"
        chunk_retain_period  = "1m"
        max_transfer_retries = 0
      }

      limits_config = {
        ingestion_rate_mb             = 10
        ingestion_burst_size_mb       = 20
        enforce_metric_name           = false
        reject_old_samples            = true
        reject_old_samples_max_age    = "168h"
        max_cache_freshness_per_query = "10m"
        max_concurrent_tail_requests  = 20
      }

      table_manager = {
        retention_deletes_enabled = true
        retention_period          = "2160h"
        creation_grace_period     = "10m"
        poll_interval             = "2m"
      }

      query_range = {
        align_queries_with_step   = true
        max_retries               = 5
        split_queries_by_interval = "15m"
        cache_results             = true
      }

      frontend = {
        log_queries_longer_than    = "5s"
        compress_responses         = true
        max_outstanding_per_tenant = 300
      }

      ruler = {
        alertmanager_url = "https://alertmanager.xx"
        external_url     = "https://alertmanager.xx"
      }

      compactor = {
        compaction_interval           = "10m"
        retention_enabled             = true
        retention_delete_delay        = "2160h"
        retention_delete_worker_count = 150
        delete_request_cancel_period  = "24h"
        max_compaction_parallelism    = 1
      }
    }
  }

  loki_helm_default_values = {
    "fullnameOverride" = local.loki["name"]

    "serviceAccount" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn"               = module.loki_eks_iam_role.service_account_role_arn
        "eks.amazonaws.com/sts-regional-endpoints" = var.sts_regional_endpoints_enabled
      }
    }

    "serviceMonitor" = {
      "enabled"       = true
      "interval"      = "30s"
      "scrapeTimeout" = "10s"
    }

    "memcachedExporter" = {
      "enabled" = true
    }

    "loki" = {
      "config" = <<-EOT
        auth_enabled: ${local.loki["config"]["auth_enabled"]}
        server:
          http_listen_port: 3100
        distributor:
          ring:
            kvstore:
              store: memberlist
        memberlist:
          join_members:
            - {{ include "loki.fullname" . }}-memberlist
        ingester:
          lifecycler:
            ring:
              kvstore:
                store: memberlist
              replication_factor: ${local.loki["config"]["ingester"]["replication_factor"]}
          max_chunk_age: ${local.loki["config"]["ingester"]["max_chunk_age"]}
          chunk_idle_period: ${local.loki["config"]["ingester"]["chunk_idle_period"]}
          chunk_block_size: ${local.loki["config"]["ingester"]["chunk_block_size"]}
          chunk_target_size: ${local.loki["config"]["ingester"]["chunk_target_size"]}
          chunk_encoding: ${local.loki["config"]["ingester"]["chunk_encoding"]}
          chunk_retain_period: ${local.loki["config"]["ingester"]["chunk_retain_period"]}
          max_transfer_retries: ${local.loki["config"]["ingester"]["max_transfer_retries"]}
          wal:
            dir: /var/loki/wal
        limits_config:
          ingestion_rate_mb: ${local.loki["config"]["limits_config"]["ingestion_rate_mb"]}
          ingestion_burst_size_mb: ${local.loki["config"]["limits_config"]["ingestion_burst_size_mb"]}
          enforce_metric_name: ${local.loki["config"]["limits_config"]["enforce_metric_name"]}
          reject_old_samples: ${local.loki["config"]["limits_config"]["reject_old_samples"]}
          reject_old_samples_max_age: ${local.loki["config"]["limits_config"]["reject_old_samples_max_age"]}
          max_cache_freshness_per_query: ${local.loki["config"]["limits_config"]["max_cache_freshness_per_query"]}
          max_concurrent_tail_requests: ${local.loki["config"]["limits_config"]["max_concurrent_tail_requests"]}
        schema_config:
          configs:
            - from: ${formatdate("YYYY-MM-DD", local.currnet_time_rfc3339)}
              store: boltdb-shipper
              object_store: s3
              schema: v11
              index:
                prefix: loki_index_
                period: 24h
        storage_config:
          boltdb_shipper:
            shared_store: s3
            active_index_directory: /var/loki/index
            cache_location: /var/loki/cache
            cache_ttl: 168h
            {{- if .Values.indexGateway.enabled }}
            index_gateway_client:
              server_address: dns:///{{ include "loki.indexGatewayFullname" . }}:9095
            {{- end }}
          aws:
            bucketnames: ${module.loki_s3_bucket.bucket_id}
            region: ${local.region}
        chunk_store_config:
          max_look_back_period: 0s
        table_manager:
          retention_deletes_enabled: ${local.loki["config"]["table_manager"]["retention_deletes_enabled"]}
          retention_period: ${local.loki["config"]["table_manager"]["retention_period"]}
          creation_grace_period: ${local.loki["config"]["table_manager"]["creation_grace_period"]}
          poll_interval: ${local.loki["config"]["table_manager"]["poll_interval"]}
        query_range:
          align_queries_with_step: ${local.loki["config"]["query_range"]["align_queries_with_step"]}
          max_retries: ${local.loki["config"]["query_range"]["max_retries"]}
          split_queries_by_interval: ${local.loki["config"]["query_range"]["split_queries_by_interval"]}
          cache_results: ${local.loki["config"]["query_range"]["cache_results"]}
          results_cache:
            cache:
              enable_fifocache: true
              fifocache:
                max_size_items: 1024
                validity: 24h
        frontend_worker:
          frontend_address: {{ include "loki.queryFrontendFullname" . }}:9095
        frontend:
          log_queries_longer_than: ${local.loki["config"]["frontend"]["log_queries_longer_than"]}
          compress_responses: ${local.loki["config"]["frontend"]["compress_responses"]}
          max_outstanding_per_tenant: ${local.loki["config"]["frontend"]["max_outstanding_per_tenant"]}
          tail_proxy_url: http://{{ include "loki.querierFullname" . }}:3100
        compactor:
          shared_store: s3
          working_directory: /loki/compactor
          compaction_interval: ${local.loki["config"]["compactor"]["compaction_interval"]}
          retention_enabled: ${local.loki["config"]["compactor"]["retention_enabled"]}
          retention_delete_delay: ${local.loki["config"]["compactor"]["retention_delete_delay"]}
          retention_delete_worker_count: ${local.loki["config"]["compactor"]["retention_delete_worker_count"]}
          delete_request_cancel_period: ${local.loki["config"]["compactor"]["delete_request_cancel_period"]}
          max_compaction_parallelism: ${local.loki["config"]["compactor"]["max_compaction_parallelism"]}
        ruler:
          storage:
            type: local
            local:
              directory: /var/loki/rules
          ring:
            kvstore:
              store: memberlist
          rule_path: /tmp/loki/scratch
          alertmanager_url: ${local.loki["config"]["ruler"]["alertmanager_url"]}
          external_url: ${local.loki["config"]["ruler"]["external_url"]}
      EOT
    }

    "tableManager" = {
      "enabled" = true
    }

    "ruler" = {
      "enabled" = true
    }

    "compactor" = {
      "enabled" = true

      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn"               = module.loki_compactor_eks_iam_role.service_account_role_arn
          "eks.amazonaws.com/sts-regional-endpoints" = var.sts_regional_endpoints_enabled
        }
      }
    }
  }

  loki = defaults(var.loki, merge(local.helm_default_params, local.loki_helm_default_params))
}

data "utils_deep_merge_yaml" "loki" {
  count = local.loki_enabled ? 1 : 0

  input = [
    yamlencode(local.loki_helm_default_values),
    local.loki["override_values"]
  ]
}

module "loki_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.loki_enabled
  context = module.this.context
}

module "loki_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.46.0"

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false
  force_destroy      = true
  sse_algorithm      = "AES256"

  lifecycle_rules = [
    {
      enabled = false
      prefix  = ""
      tags    = {}

      enable_glacier_transition            = false
      enable_deeparchive_transition        = false
      enable_standard_ia_transition        = false
      enable_current_object_expiration     = false
      enable_noncurrent_version_expiration = false

      abort_incomplete_multipart_upload_days         = 90
      noncurrent_version_glacier_transition_days     = 30
      noncurrent_version_deeparchive_transition_days = 60
      noncurrent_version_expiration_days             = 90

      standard_transition_days    = 30
      glacier_transition_days     = 60
      deeparchive_transition_days = 90
      expiration_days             = 90
    }
  ]

  context    = module.loki_label.context
  attributes = [local.loki["name"]]
}

data "aws_iam_policy_document" "loki" {
  count = local.loki_enabled ? 1 : 0

  statement {
    effect = "Allow"

    resources = [
      format("%s/*", module.loki_s3_bucket.bucket_arn),
      module.loki_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:ListObjects",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
  }
}

module "loki_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.loki[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.loki["name"]
  service_account_namespace   = local.loki["namespace"]

  context = module.loki_label.context
}

module "loki_compactor_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.loki[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = format("%s-%s", local.loki["name"], "compactor")
  service_account_namespace   = local.loki["namespace"]

  context = module.loki_label.context
}


resource "helm_release" "loki" {
  count = local.loki_enabled ? 1 : 0

  name              = local.loki["name"]
  repository        = local.loki["repository"]
  chart             = local.loki["chart"]
  version           = local.loki["version"]
  namespace         = local.loki["namespace"]
  max_history       = local.loki["max_history"]
  create_namespace  = local.loki["create_namespace"]
  dependency_update = local.loki["dependency_update"]
  reuse_values      = local.loki["reuse_values"]
  wait              = local.loki["wait"]
  timeout           = local.loki["timeout"]
  values            = [one(data.utils_deep_merge_yaml.loki[*].output)]

  depends_on = [
    local.default_depends_on
  ]
}
