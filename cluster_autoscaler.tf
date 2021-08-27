locals {
  cluster_autoscaler_enabled = module.this.enabled && contains(var.apps_to_install, "cluster_autoscaler")
  cluster_autoscaler         = defaults(var.cluster_autoscaler, merge(local.helm_default_params, local.cluster_autoscaler_helm_default_params))
  cluster_autoscaler_helm_default_params = {
    repository      = "https://kubernetes.github.io/autoscaler"
    chart           = "cluster-autoscaler"
    version         = "9.10.5"
    override_values = ""
  }
  cluster_autoscaler_helm_default_values = {
    "fullnameOverride" = "${local.cluster_autoscaler["name"]}"
    "cloudProvider"    = "aws"
    "awsRegion"        = "${local.region}"
    "autoDiscovery" = {
      "clusterName" = "${local.eks_cluster_id}"
    }
    "rbac" = {
      "serviceAccount" = {
        "annotations" = {
          "eks.amazonaws.com/role-arn" = "${module.cluster_autoscaler_eks_iam_role.service_account_role_arn}"
        }
      }
    }
  }
}

data "utils_deep_merge_yaml" "cluster_autoscaler" {
  count = local.cluster_autoscaler_enabled ? 1 : 0

  input = [
    yamlencode(local.cluster_autoscaler_helm_default_values),
    local.cluster_autoscaler["override_values"]
  ]
}

module "cluster_autoscaler_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled = local.cluster_autoscaler_enabled
  context = module.this.context
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  count = local.cluster_autoscaler_enabled ? 1 : 0

  statement {
    sid       = "ClusterAutoscaler"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
  }
}

module "cluster_autoscaler_eks_iam_role" {
  source = "git::https://github.com/SweetOps/terraform-aws-eks-iam-role.git?ref=switch_to_count"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.cluster_autoscaler[*].json)
  aws_partition               = local.partition
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.cluster_autoscaler["name"]
  service_account_namespace   = local.cluster_autoscaler["namespace"]

  context = module.cluster_autoscaler_label.context
}

resource "helm_release" "cluster_autoscaler" {
  count = local.cluster_autoscaler_enabled ? 1 : 0

  name              = local.cluster_autoscaler["name"]
  repository        = local.cluster_autoscaler["repository"]
  chart             = local.cluster_autoscaler["chart"]
  version           = local.cluster_autoscaler["version"]
  namespace         = local.cluster_autoscaler["namespace"]
  max_history       = local.cluster_autoscaler["max_history"]
  create_namespace  = local.cluster_autoscaler["create_namespace"]
  dependency_update = local.cluster_autoscaler["dependency_update"]
  values            = [one(data.utils_deep_merge_yaml.cluster_autoscaler[*].output)]

  depends_on = [
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns,
    module.cluster_autoscaler_eks_iam_role
  ]
}
