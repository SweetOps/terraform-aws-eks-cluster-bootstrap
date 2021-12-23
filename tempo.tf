locals {
  tempo_enabled = module.this.enabled && contains(var.apps_to_install, "tempo")

  tempo_helm_default_params = {
    repository      = "https://grafana.github.io/helm-charts"
    chart           = "tempo-distributed"
    version         = "0.12.2"
    override_values = ""
  }

  tempo_helm_default_values = {
    "fullnameOverride" = local.tempo["name"]
    "serviceAccount" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = module.tempo_eks_iam_role.service_account_role_arn
      }
    }

    "storage" = {
      "trace" = {
        "backend" = "s3"
        "s3" = {
          "bucket"   = module.tempo_s3_bucket.bucket_id
          "endpoint" = trimprefix(module.tempo_s3_bucket.bucket_regional_domain_name, "${module.tempo_s3_bucket.bucket_id}.")
        }
      }
    }

    "memcachedExporter" = {
      "enabled" = true
    }

    "serviceMonitor" = {
      "enabled"       = true
      "interval"      = "30s"
      "scrapeTimeout" = "10s"
    }
  }

  tempo = defaults(var.tempo, merge(local.helm_default_params, local.tempo_helm_default_params))
}

data "utils_deep_merge_yaml" "tempo" {
  count = local.tempo_enabled ? 1 : 0

  input = [
    yamlencode(local.tempo_helm_default_values),
    local.tempo["override_values"]
  ]
}

module "tempo_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled = local.tempo_enabled
  context = module.this.context
}

module "tempo_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.43.0"

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

  context    = module.tempo_label.context
  attributes = [local.tempo["name"]]
}

data "aws_iam_policy_document" "tempo" {
  count = local.tempo_enabled ? 1 : 0

  statement {
    effect = "Allow"

    resources = [
      format("%s/*", module.tempo_s3_bucket.bucket_arn),
      module.tempo_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetObjectTagging",
      "s3:PutObjectTagging"
    ]
  }
}

module "tempo_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.tempo[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.tempo["name"]
  service_account_namespace   = local.tempo["namespace"]

  context = module.tempo_label.context
}

resource "helm_release" "tempo" {
  count = local.tempo_enabled ? 1 : 0

  name              = local.tempo["name"]
  repository        = local.tempo["repository"]
  chart             = local.tempo["chart"]
  version           = local.tempo["version"]
  namespace         = local.tempo["namespace"]
  max_history       = local.tempo["max_history"]
  create_namespace  = local.tempo["create_namespace"]
  dependency_update = local.tempo["dependency_update"]
  reuse_values      = local.tempo["reuse_values"]
  wait              = local.tempo["wait"]
  timeout           = local.tempo["timeout"]
  values            = [one(data.utils_deep_merge_yaml.tempo[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns,
    helm_release.ebs_csi_driver,
    helm_release.ingress_nginx,
    helm_release.cluster_autoscaler
  ]
}
