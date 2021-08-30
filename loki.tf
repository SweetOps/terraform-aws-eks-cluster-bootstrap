## TODO: implement mTLS
locals {
  loki_enabled = module.this.enabled && contains(var.apps_to_install, "loki")
  loki_helm_default_params = {
    repository      = "https://grafana.github.io/helm-charts"
    chart           = "loki-distributed"
    version         = "0.36.0"
    override_values = ""
  }
  loki_helm_default_values = {
    "fullnameOverride" = "${local.loki["name"]}"
    "serviceAccount" = {
      "annotations" = {
        "eks.amazonaws.com/role-arn" = "${module.loki_eks_iam_role.service_account_role_arn}"
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
  version = "0.24.1"

  enabled = local.loki_enabled
  context = module.this.context
}

module "loki_s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.43.0"

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

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
  source = "git::https://github.com/SweetOps/terraform-aws-eks-iam-role.git?ref=switch_to_count"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.loki[*].json)
  aws_partition               = local.partition
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.loki["name"]
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
    module.loki_eks_iam_role,
    module.loki_s3_bucket,
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.ingress_nginx,
    helm_release.victoria_metrics
  ]
}
