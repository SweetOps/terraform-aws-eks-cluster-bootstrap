locals {
  piggy_webhooks_enabled             = module.this.enabled && contains(var.apps_to_install, "piggy_webhooks")
  piggy_webhooks                     = defaults(var.piggy_webhooks, merge(local.helm_default_params, local.piggy_webhooks_helm_default_params))
  piggy_webhooks_iam_role_enabled    = local.piggy_webhooks_enabled && local.piggy_webhooks["create_default_iam_role"]
  piggy_webhooks_iam_policy_enabled  = local.piggy_webhooks_enabled && local.piggy_webhooks["create_default_iam_policy"]
  piggy_webhooks_iam_policy_document = local.piggy_webhooks_iam_policy_enabled ? one(data.aws_iam_policy_document.piggy_webhooks[*].json) : local.piggy_webhooks["iam_policy_document"]

  piggy_webhooks_helm_default_params = {
    repository                = "https://piggysec.com"
    chart                     = "piggy-webhooks"
    version                   = "0.2.9"
    override_values           = ""
    create_default_iam_policy = true
    create_default_iam_role   = true
    iam_policy_document       = "{}"
  }

  piggy_webhooks_helm_default_values = templatefile("${path.module}/helm-values/piggy-webhooks.yaml",
    {
      fullname_override      = local.piggy_webhooks["name"]
      region                 = local.region
      sts_regional_endpoints = tostring(var.sts_regional_endpoints_enabled)
      role_arn               = module.piggy_webhooks_eks_iam_role.service_account_role_arn
      role_enabled           = local.piggy_webhooks_iam_role_enabled
    }
  )
}

data "utils_deep_merge_yaml" "piggy_webhooks" {
  count = local.piggy_webhooks_enabled ? 1 : 0

  input = [
    local.piggy_webhooks_helm_default_values,
    local.piggy_webhooks["override_values"]
  ]
}

module "piggy_webhooks_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.piggy_webhooks_iam_role_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "piggy_webhooks" {
  count = local.piggy_webhooks_iam_role_enabled ? (local.piggy_webhooks_iam_policy_enabled ? 1 : 0) : 0

  statement {
    sid       = "PiggySecretReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:ListSecrets"
    ]
  }

  statement {
    sid       = "PiggyECRReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer"
    ]
  }

  statement {
    sid       = "PiggyKMSDecrypt"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Decrypt"
    ]
  }
}

module "piggy_webhooks_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = local.piggy_webhooks_iam_policy_document
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.piggy_webhooks["name"]
  service_account_namespace   = local.piggy_webhooks["namespace"]

  context = module.piggy_webhooks_label.context
}

resource "helm_release" "piggy_webhooks" {
  count = local.piggy_webhooks_enabled ? 1 : 0

  name              = local.piggy_webhooks["name"]
  repository        = local.piggy_webhooks["repository"]
  chart             = local.piggy_webhooks["chart"]
  version           = local.piggy_webhooks["version"]
  namespace         = local.piggy_webhooks["namespace"]
  max_history       = local.piggy_webhooks["max_history"]
  create_namespace  = local.piggy_webhooks["create_namespace"]
  dependency_update = local.piggy_webhooks["dependency_update"]
  reuse_values      = local.piggy_webhooks["reuse_values"]
  wait              = local.piggy_webhooks["wait"]
  timeout           = local.piggy_webhooks["timeout"]
  values            = [one(data.utils_deep_merge_yaml.piggy_webhooks[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.cluster_autoscaler
  ]
}
