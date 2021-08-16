locals {
  ebs_csi_driver_enabled = module.this.enabled && contains(var.apps_to_install, "ebs_csi_driver")
}

module "ebs_csi_driver_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled    = local.ebs_csi_driver_enabled
  attributes = ["ebs", "csi", "driver"]
  context    = module.this.context
}

module "ebs_csi_driver_eks_iam_policy" {
  source  = "cloudposse/iam-policy/aws"
  version = "0.2.1"

  iam_source_json_url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

  context = module.ebs_csi_driver_label.context
}

module "ebs_csi_driver_eks_iam_role" {
  source  = "cloudposse/eks-iam-role/aws"
  version = "0.10.0"

  aws_iam_policy_document     = module.ebs_csi_driver_eks_iam_policy.json
  aws_partition               = one(data.aws_partition.default[*].partition)
  eks_cluster_oidc_issuer_url = one(data.aws_eks_cluster.default[*].identity[0].oidc[0].issuer)
  service_account_name        = var.ebs_csi_driver["name"]
  service_account_namespace   = var.ebs_csi_driver["namespace"]

  context = module.ebs_csi_driver_label.context
}

resource "helm_release" "ebs_csi_driver" {
  count = local.ebs_csi_driver_enabled ? 1 : 0

  name              = var.ebs_csi_driver["name"]
  repository        = var.ebs_csi_driver["repository"]
  chart             = var.ebs_csi_driver["chart"]
  version           = var.ebs_csi_driver["version"]
  namespace         = var.ebs_csi_driver["namespace"]
  max_history       = var.ebs_csi_driver["max_history"]
  create_namespace  = var.ebs_csi_driver["create_namespace"]
  dependency_update = var.ebs_csi_driver["dependency_update"]
  values            = var.ebs_csi_driver["values"]

  set {
    name  = "fullnameOverride"
    value = var.ebs_csi_driver["name"]
  }

  set {
    name  = "controller.k8sTagClusterId"
    value = one(data.aws_eks_cluster.default[*].id)
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.ebs_csi_driver_eks_iam_role.service_account_role_arn
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.ebs_csi_driver_eks_iam_role.service_account_role_arn
  }

  depends_on = [
    module.ebs_csi_driver_eks_iam_role
  ]
}
