locals {
  argocd_enabled                                     = module.this.enabled && contains(var.apps_to_install, "argocd")
  argocd_application_controller_service_account_name = format("%s-application-controller", local.argocd["name"])
  argocd_server_service_account_name                 = format("%s-server", local.argocd["name"])
  argocd                                             = defaults(var.argocd, merge(local.helm_default_params, local.argocd_helm_default_params))

  argocd_helm_default_params = {
    repository      = "https://argoproj.github.io/argo-helm"
    chart           = "argo-cd"
    version         = "3.18.0"
    override_values = ""
  }

  argocd_helm_default_values = {
    "fullnameOverride" = local.argocd["name"]
    "global" = {
      "securityContext" = {
        "runAsUser"  = 999
        "runAsGroup" = 999
        "fsGroup"    = 999
      }
    }
    "controller" = {
      "serviceAccount" = {
        "name" = local.argocd_application_controller_service_account_name
        "annotations" = {
          "eks.amazonaws.com/role-arn" = module.argocd_application_controller_eks_iam_role.service_account_role_arn
        }
      }
    }
    "server" = {
      "serviceAccount" = {
        "name" = local.argocd_server_service_account_name
        "annotations" = {
          "eks.amazonaws.com/role-arn" = module.argocd_server_eks_iam_role.service_account_role_arn
        }
      }
    }
  }
}

data "utils_deep_merge_yaml" "argocd" {
  count = local.argocd_enabled ? 1 : 0

  input = [
    yamlencode(local.argocd_helm_default_values),
    local.argocd["override_values"]
  ]
}

data "aws_iam_policy_document" "argocd" {
  count = local.argocd_enabled ? 1 : 0

  statement {
    effect = "Allow"

    resources = ["arn:aws:iam::${local.account_id}:role/*-argocd-deployer"]

    actions = [
      "sts:AssumeRole"
    ]
  }
}

module "argocd_server_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.0"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.argocd[*].json)
  aws_partition               = local.partition
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.argocd_server_service_account_name
  service_account_namespace   = local.argocd["namespace"]

  enabled = local.argocd_enabled
  context = module.this.context
}

module "argocd_application_controller_eks_iam_role" {
  source  = "rallyware/eks-iam-role/aws"
  version = "0.1.0"

  aws_iam_policy_document     = one(data.aws_iam_policy_document.argocd[*].json)
  aws_partition               = local.partition
  eks_cluster_oidc_issuer_url = local.eks_cluster_oidc_issuer_url
  service_account_name        = local.argocd_application_controller_service_account_name
  service_account_namespace   = local.argocd["namespace"]

  enabled = local.argocd_enabled
  context = module.this.context
}

resource "helm_release" "argocd" {
  count = local.argocd_enabled ? 1 : 0

  name              = local.argocd["name"]
  repository        = local.argocd["repository"]
  chart             = local.argocd["chart"]
  version           = local.argocd["version"]
  namespace         = local.argocd["namespace"]
  max_history       = local.argocd["max_history"]
  create_namespace  = local.argocd["create_namespace"]
  dependency_update = local.argocd["dependency_update"]
  reuse_values      = local.argocd["reuse_values"]
  wait              = local.argocd["wait"]
  timeout           = local.argocd["timeout"]
  values            = [one(data.utils_deep_merge_yaml.argocd[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.node_local_dns,
    helm_release.kube_prometheus_stack,
    helm_release.ingress_nginx,
    helm_release.cluster_autoscaler
  ]
}
