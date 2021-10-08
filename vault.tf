## TODO: implement mTLS
locals {
  vault_enabled              = module.this.enabled && contains(var.apps_to_install, "vault")
  vault_create_aws_resources = local.vault_enabled && local.vault["create_aws_resources"]
  vault                      = defaults(var.vault, merge(local.helm_default_params, local.vault_helm_default_params))

  vault_helm_default_params = {
    repository           = "https://helm.releases.hashicorp.com"
    chart                = "vault"
    version              = "0.15.0"
    override_values      = ""
    create_aws_resources = true
  }

  vault_helm_default_values = local.vault_enabled && local.vault_create_aws_resources ? yamlencode({
    "fullnameOverride" = "${local.vault["name"]}"

    "global" = {
      "enabled" = true
    }

    "injector" = {
      "authPath" = "auth/kubernetes"
      "enabled"  = true
      "metrics" = {
        "enabled" = false
      }
    }

    "server" = {
      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn" = "${module.vault_eks_iam_role.service_account_role_arn}"
        }
      }

      "dev" = {
        "enabled" = false
      }

      "enabled" = true

      "ha" = {
        "apiAddr" = null
        "config"  = <<-EOT
      service_registration "kubernetes" {}
      ui = true
      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "dynamodb" {
        ha_enabled = "true"
        region     = "${local.region}"
        table      = "${module.vault_dynamodb_table.table_name}"
      }
      seal "awskms" {
        region     = "${local.region}"
        kms_key_id = "${module.vault_kms_key.key_id}"
      }
      EOT
        "enabled" = true
        "raft" = {
          "enabled" = false
        }
        "replicas" = 3
      }

      "standalone" = {
        "enabled" = false
      }
    }
  }) : yamlencode({ "fullnameOverride" = "${local.vault["name"]}" })
}

data "utils_deep_merge_yaml" "vault" {
  count = local.vault_enabled ? 1 : 0

  input = [
    local.vault_helm_default_values,
    local.vault["override_values"]
  ]
}

module "vault_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled = local.vault_create_aws_resources
  context = module.this.context
}

module "vault_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.10.0"

  description             = format("KMS key for vault on %s", local.eks_cluster_id)
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = format("alias/%s/vault", local.eks_cluster_id)

  context    = module.vault_label.context
  attributes = [local.vault["name"]]
}

module "vault_dynamodb_table" {
  source  = "cloudposse/dynamodb/aws"
  version = "0.29.0"

  hash_key                      = "Path"
  range_key                     = "Key"
  enable_autoscaler             = false
  enable_point_in_time_recovery = true

  dynamodb_attributes = [
    {
      name = "Path"
      type = "S"
    },
    {
      name = "Key"
      type = "S"
    }
  ]

  context    = module.vault_label.context
  attributes = [local.vault["name"]]
}

data "aws_iam_policy_document" "vault" {
  count = local.vault_create_aws_resources ? 1 : 0

  statement {
    effect = "Allow"

    resources = [
      module.vault_dynamodb_table.table_arn
    ]

    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      module.vault_kms_key.key_arn
    ]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

module "vault_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.vault[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.vault["name"]
  service_account_namespace   = local.vault["namespace"]

  context = module.vault_label.context
}

resource "helm_release" "vault" {
  count = local.vault_enabled ? 1 : 0

  name              = local.vault["name"]
  repository        = local.vault["repository"]
  chart             = local.vault["chart"]
  version           = local.vault["version"]
  namespace         = local.vault["namespace"]
  max_history       = local.vault["max_history"]
  create_namespace  = local.vault["create_namespace"]
  dependency_update = local.vault["dependency_update"]
  reuse_values      = local.vault["reuse_values"]
  wait              = local.vault["wait"]
  timeout           = local.vault["timeout"]
  values            = [one(data.utils_deep_merge_yaml.vault[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns,
    helm_release.ingress_nginx,
    helm_release.cluster_autoscaler
  ]
}
