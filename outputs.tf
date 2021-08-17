output "cert_manager_metadata" {
  value       = local.cert_manager_enabled ? helm_release.cert_manager[0].metadata : null
  description = "Block status of the deployed cert-manager."
}

output "victoria_metrics_metadata" {
  value       = local.victoria_metrics_enabled ? helm_release.victoria_metrics[0].metadata : null
  description = "Block status of the deployed victoria-metrics."
}

### template
output "cluster_autoscaler_metadata" {
  value       = local.cluster_autoscaler_enabled ? helm_release.cluster_autoscaler[0].metadata : null
  description = "Block status of the deployed cluster-autoscaler."
}

output "cluster_autoscaler_service_account_role_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_name
  description = "IAM role name"
}

output "cluster_autoscaler_service_account_role_unique_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_unique_id
  description = "IAM role unique ID"
}

output "cluster_autoscaler_service_account_role_arn" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_role_arn
  description = "IAM role ARN"
}

output "cluster_autoscaler_service_account_policy_name" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_name
  description = "IAM policy name"
}

output "cluster_autoscaler_service_account_policy_id" {
  value       = module.cluster_autoscaler_eks_iam_role.service_account_policy_id
  description = "IAM policy ID"
}
###

output "ebs_csi_driver_metadata" {
  value       = local.ebs_csi_driver_enabled ? helm_release.ebs_csi_driver[0].metadata : null
  description = "Block status of the deployed cluster-autoscaler."
}

output "ebs_csi_driver_service_account_role_name" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_name
  description = "IAM role name"
}

output "ebs_csi_driver_service_account_role_unique_id" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_unique_id
  description = "IAM role unique ID"
}

output "ebs_csi_driver_service_account_role_arn" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_role_arn
  description = "IAM role ARN"
}

output "ebs_csi_driver_service_account_policy_name" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_policy_name
  description = "IAM policy name"
}

output "ebs_csi_driver_service_account_policy_id" {
  value       = module.ebs_csi_driver_eks_iam_role.service_account_policy_id
  description = "IAM policy ID"
}
