locals {
  helm_default_params = {
    max_history       = 10
    create_namespace  = true
    dependency_update = true
    reuse_values      = false
    timeout           = 300
  }
  eks_cluster_id              = one(data.aws_eks_cluster.default[*].id)
  eks_cluster_oidc_issuer_url = one(data.aws_eks_cluster.default[*].identity[0].oidc[0].issuer)
  region                      = one(data.aws_region.default[*].name)
  partition                   = one(data.aws_partition.default[*].partition)
  account_id                  = one(data.aws_caller_identity.default[*].account_id)
}

data "aws_partition" "default" {
  count = module.this.enabled ? 1 : 0
}

data "aws_eks_cluster" "default" {
  count = module.this.enabled ? 1 : 0

  name = var.eks_cluster_id
}

data "aws_region" "default" {
  count = module.this.enabled ? 1 : 0
}

data "aws_caller_identity" "default" {
  count = module.this.enabled ? 1 : 0
}
