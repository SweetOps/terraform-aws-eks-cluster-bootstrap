data "aws_partition" "current" {
  count = module.this.enabled ? 1 : 0
}
