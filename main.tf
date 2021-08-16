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
