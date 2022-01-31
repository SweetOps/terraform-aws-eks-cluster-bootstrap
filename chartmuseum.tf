locals {
  chartmuseum_enabled = module.this.enabled && contains(var.apps_to_install, "chartmuseum")
  chartmuseum_helm_default_params = {
    repository      = "https://chartmuseum.github.io/charts"
    chart           = "chartmuseum"
    version         = "3.3.0"
    override_values = ""
  }
  chartmuseum_helm_default_values = {
    "fullnameOverride" = local.chartmuseum["name"]
    "env" = {
      "open" = {
        "STORAGE"               = "amazon"
        "STORAGE_AMAZON_BUCKET" = module.chartmuseum_s3_bucket.bucket_id
        "STORAGE_AMAZON_REGION" = local.region
        "STORAGE_AMAZON_SSE"    = "AES256"
        "AWS_SDK_LOAD_CONFIG"   = true
      }
    }
    "serviceAccount" = {
      "create" = true
      "annotations" = {
        "eks.amazonaws.com/role-arn"               = module.chartmuseum_eks_iam_role.service_account_role_arn
        "eks.amazonaws.com/sts-regional-endpoints" = tostring(var.sts_regional_endpoints_enabled)
      }
    }
  }

  chartmuseum = defaults(var.chartmuseum, merge(local.helm_default_params, local.chartmuseum_helm_default_params))
}

data "utils_deep_merge_yaml" "chartmuseum" {
  count = local.chartmuseum_enabled ? 1 : 0

  input = [
    yamlencode(local.chartmuseum_helm_default_values),
    local.chartmuseum["override_values"]
  ]
}

module "chartmuseum_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.chartmuseum_enabled
  context = module.this.context
}

module "chartmuseum_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.46.0"

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

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

  context    = module.chartmuseum_label.context
  attributes = [local.chartmuseum["name"]]
}

data "aws_iam_policy_document" "chartmuseum" {
  count = local.chartmuseum_enabled ? 1 : 0

  statement {
    sid    = "ChartmuseumAllowListObjects"
    effect = "Allow"

    resources = [
      module.chartmuseum_s3_bucket.bucket_arn
    ]

    actions = [
      "s3:ListBucket"
    ]
  }

  statement {
    sid    = "ChartmuseumAllowObjectsCRUD"
    effect = "Allow"

    resources = [
      format("%s/*", module.chartmuseum_s3_bucket.bucket_arn)
    ]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
  }
}

module "chartmuseum_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.chartmuseum[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.chartmuseum["name"]
  service_account_namespace   = local.chartmuseum["namespace"]

  context = module.chartmuseum_label.context
}

resource "helm_release" "chartmuseum" {
  count = local.chartmuseum_enabled ? 1 : 0

  name              = local.chartmuseum["name"]
  repository        = local.chartmuseum["repository"]
  chart             = local.chartmuseum["chart"]
  version           = local.chartmuseum["version"]
  namespace         = local.chartmuseum["namespace"]
  max_history       = local.chartmuseum["max_history"]
  create_namespace  = local.chartmuseum["create_namespace"]
  dependency_update = local.chartmuseum["dependency_update"]
  reuse_values      = local.chartmuseum["reuse_values"]
  wait              = local.chartmuseum["wait"]
  timeout           = local.chartmuseum["timeout"]
  values            = [one(data.utils_deep_merge_yaml.chartmuseum[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns,
    helm_release.ebs_csi_driver,
    helm_release.ingress_nginx,
    helm_release.cluster_autoscaler
  ]
}
