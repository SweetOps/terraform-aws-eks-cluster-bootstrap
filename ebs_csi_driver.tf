locals {
  ebs_csi_driver_enabled = module.this.enabled && contains(var.apps_to_install, "ebs_csi_driver")
  ebs_csi_driver         = defaults(var.ebs_csi_driver, merge(local.helm_default_params, local.ebs_csi_driver_helm_default_params))
  ebs_csi_driver_helm_default_params = {
    repository      = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
    chart           = "aws-ebs-csi-driver"
    version         = "2.1.0"
    override_values = ""
  }
  ebs_csi_driver_helm_default_values = {
    "fullnameOverride" = local.ebs_csi_driver["name"]
    "controller" = {
      "extraCreateMetadata" = true
      "k8sTagClusterId"     = local.eks_cluster_id
      "region"              = local.region
      "tolerateAllTaints"   = true
      "updateStrategy" = {
        "rollingUpdate" = {
          "maxSurge"       = 0
          "maxUnavailable" = 1
        }
        "type" = "RollingUpdate"
      }
      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn"               = module.ebs_csi_driver_eks_iam_role.service_account_role_arn
          "eks.amazonaws.com/sts-regional-endpoints" = var.sts_regional_endpoints_enabled
        }
      }
    }
    "enableVolumeResizing" = true
    "enableVolumeSnapshot" = true
    "storageClasses" = [
      {
        "allowVolumeExpansion" = true
        "annotations" = {
          "storageclass.kubernetes.io/is-default-class" = "true"
        }
        "labels" = {
          "type" = "gp3"
        }
        "name" = "ebs-gp3"
        "parameters" = {
          "csi.storage.k8s.io/fstype" = "xfs"
          "encrypted"                 = "true"
          "kmsKeyId"                  = module.ebs_csi_driver_kms_key.key_id
          "type"                      = "gp3"
        }
        "provisioner"       = "ebs.csi.aws.com"
        "reclaimPolicy"     = "Delete"
        "volumeBindingMode" = "WaitForFirstConsumer"
      },
    ]
  }
}

data "utils_deep_merge_yaml" "ebs_csi_driver" {
  count = local.ebs_csi_driver_enabled ? 1 : 0

  input = [
    yamlencode(local.ebs_csi_driver_helm_default_values),
    local.ebs_csi_driver["override_values"]
  ]
}

module "ebs_csi_driver_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled = local.ebs_csi_driver_enabled
  context = module.this.context
}

module "ebs_csi_driver_kms_key" {
  source  = "cloudposse/kms-key/aws"
  version = "0.12.1"

  description             = format("KMS key for ebs-csi-driver on %s", local.eks_cluster_id)
  deletion_window_in_days = 10
  enable_key_rotation     = true
  alias                   = format("alias/%s/ebs-csi-driver", local.eks_cluster_id)

  context = module.ebs_csi_driver_label.context
}

data "aws_iam_policy_document" "ebs_csi_driver" {
  count = local.ebs_csi_driver_enabled ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
    ]
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "CreateVolume",
        "CreateSnapshot",
      ]
    }
  }

  statement {
    effect = "Allow"

    resources = [
      "arn:${local.partition}:ec2:*:*:volume/*",
      "arn:${local.partition}:ec2:*:*:snapshot/*",
    ]

    actions = ["ec2:DeleteTags"]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:CreateVolume"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteVolume"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/*"
      values   = ["owned"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteSnapshot"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteSnapshot"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = [module.ebs_csi_driver_kms_key.key_arn]

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    effect    = "Allow"
    resources = [module.ebs_csi_driver_kms_key.key_arn]


    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }
}

module "ebs_csi_driver_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.1"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.ebs_csi_driver[*].json)
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = "ebs-csi-controller-sa"
  service_account_namespace   = local.ebs_csi_driver["namespace"]

  context = module.ebs_csi_driver_label.context
}

resource "helm_release" "ebs_csi_driver" {
  count = local.ebs_csi_driver_enabled ? 1 : 0

  name              = local.ebs_csi_driver["name"]
  repository        = local.ebs_csi_driver["repository"]
  chart             = local.ebs_csi_driver["chart"]
  version           = local.ebs_csi_driver["version"]
  namespace         = local.ebs_csi_driver["namespace"]
  max_history       = local.ebs_csi_driver["max_history"]
  create_namespace  = local.ebs_csi_driver["create_namespace"]
  dependency_update = local.ebs_csi_driver["dependency_update"]
  reuse_values      = local.ebs_csi_driver["reuse_values"]
  wait              = local.ebs_csi_driver["wait"]
  timeout           = local.ebs_csi_driver["timeout"]
  values            = [one(data.utils_deep_merge_yaml.ebs_csi_driver[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns
  ]
}
