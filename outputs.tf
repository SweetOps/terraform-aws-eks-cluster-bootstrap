output "cert_manager_metadata" {
  value       = local.cert_manager_enabled ? helm_release.cert_manager[0].metadata : null
  description = "Block status of the deployed Cert-Manager"
}

output "node_local_dns_metadata" {
  value       = local.node_local_dns_enabled ? helm_release.node_local_dns[0].metadata : null
  description = "Block status of the deployed Node Local DNS"
}

output "kube_prometheus_stack_metadata" {
  value       = local.kube_prometheus_stack_enabled ? helm_release.kube_prometheus_stack[0].metadata : null
  description = "Block status of the deployed Kube Prometheus Stack"
}

output "aws_node_termination_handler_metadata" {
  value       = local.aws_node_termination_handler_enabled ? helm_release.aws_node_termination_handler[0].metadata : null
  description = "Block status of the deployed AWS Node Termination Handler"
}

output "external_dns_metadata" {
  value       = local.external_dns_enabled ? helm_release.external_dns[0].metadata : null
  description = "Block status of the deployed External DNS"
}

output "ingress_nginx_metadata" {
  value       = local.ingress_nginx_enabled ? helm_release.ingress_nginx[0].metadata : null
  description = "Block status of the deployed Ingress Nginx"
}

output "victoria_metrics_metadata" {
  value       = local.victoria_metrics_enabled ? helm_release.victoria_metrics[0].metadata : null
  description = "Block status of the deployed VictoriaMetrics"
}

output "cluster_autoscaler_metadata" {
  value       = local.cluster_autoscaler_enabled ? helm_release.cluster_autoscaler[0].metadata : null
  description = "Block status of the deployed Cluster-Autoscaler"
}

output "cluster_autoscaler_service_account_role_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_name
  description = "Cluster-Autoscaler IAM role name"
}

output "cluster_autoscaler_service_account_role_unique_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_unique_id
  description = "Cluster-Autoscaler IAM role unique ID"
}

output "cluster_autoscaler_service_account_role_arn" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
  description = "Cluster-Autoscaler IAM role ARN"
}

output "cluster_autoscaler_service_account_policy_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_name
  description = "Cluster-Autoscaler IAM policy name"
}

output "cluster_autoscaler_service_account_policy_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_id
  description = "Cluster-Autoscaler IAM policy ID"
}

output "ebs_csi_driver_metadata" {
  value       = local.ebs_csi_driver_enabled ? helm_release.ebs_csi_driver[0].metadata : null
  description = "Block status of the deployed EBS CSI driver"
}

output "ebs_csi_driver_service_account_role_name" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_name
  description = "EBS CSI driver IAM role name"
}

output "ebs_csi_driver_service_account_role_unique_id" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_unique_id
  description = "EBS CSI driver IAM role unique ID"
}

output "ebs_csi_driver_service_account_role_arn" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_arn
  description = "EBS CSI driver IAM role ARN"
}

output "ebs_csi_driver_service_account_policy_name" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_policy_name
  description = "EBS CSI driver IAM policy name"
}

output "ebs_csi_driver_service_account_policy_id" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_policy_id
  description = "EBS CSI driver IAM policy ID"
}

output "vault_metadata" {
  value       = local.vault_enabled ? helm_release.vault[0].metadata : null
  description = "Block status of the deployed Vault"
}

output "vault_service_account_role_name" {
  value       = module.vault_eks_iam_role.service_account_role_name
  description = "Vault IAM role name"
}

output "vault_service_account_role_unique_id" {
  value       = module.vault_eks_iam_role.service_account_role_unique_id
  description = "Vault IAM role unique ID"
}

output "vault_service_account_role_arn" {
  value       = module.vault_eks_iam_role.service_account_role_arn
  description = "Vault IAM role ARN"
}

output "vault_service_account_policy_name" {
  value       = module.vault_eks_iam_role.service_account_policy_name
  description = "Vault IAM policy name"
}

output "vault_service_account_policy_id" {
  value       = module.vault_eks_iam_role.service_account_policy_id
  description = "Vault IAM policy ID"
}

output "velero_metadata" {
  value       = local.velero_enabled ? helm_release.velero[0].metadata : null
  description = "Block status of the deployed Velero"
}

output "velero_service_account_role_name" {
  value       = module.velero_eks_iam_role.service_account_role_name
  description = "Velero IAM role name"
}

output "velero_service_account_role_unique_id" {
  value       = module.velero_eks_iam_role.service_account_role_unique_id
  description = "Velero IAM role unique ID"
}

output "velero_service_account_role_arn" {
  value       = module.velero_eks_iam_role.service_account_role_arn
  description = "Velero IAM role ARN"
}

output "velero_service_account_policy_name" {
  value       = module.velero_eks_iam_role.service_account_policy_name
  description = "Velero IAM policy name"
}

output "velero_service_account_policy_id" {
  value       = module.velero_eks_iam_role.service_account_policy_id
  description = "Velero IAM policy ID"
}

output "oauth2_proxy_metadata" {
  value       = local.oauth2_proxy_enabled ? helm_release.oauth2_proxy[0].metadata : null
  description = "Block status of the deployed OAuth2 proxy"
}

output "actions_runner_controller_metadata" {
  value       = local.actions_runner_controller_enabled ? helm_release.actions_runner_controller[0].metadata : null
  description = "Block status of the deployed GitHub Actions runner controller"
}
