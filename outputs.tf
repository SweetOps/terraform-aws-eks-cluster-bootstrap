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

output "velero_bucket_id" {
  value       = module.velero_s3_bucket.bucket_id
  description = "Velero S3 bucket name"
}

output "velero_bucket_arn" {
  value       = module.velero_s3_bucket.bucket_arn
  description = "Velero S3 bucket ARN"
}

output "oauth2_proxy_metadata" {
  value       = local.oauth2_proxy_enabled ? helm_release.oauth2_proxy[0].metadata : null
  description = "Block status of the deployed OAuth2 proxy"
}

output "actions_runner_controller_metadata" {
  value       = local.actions_runner_controller_enabled ? helm_release.actions_runner_controller[0].metadata : null
  description = "Block status of the deployed GitHub Actions runner controller"
}

output "loki_metadata" {
  value       = local.loki_enabled ? helm_release.loki[0].metadata : null
  description = "Block status of the deployed loki"
}

output "loki_service_account_role_name" {
  value       = module.loki_eks_iam_role.service_account_role_name
  description = "Grafana LokiIAM role name"
}

output "loki_service_account_role_unique_id" {
  value       = module.loki_eks_iam_role.service_account_role_unique_id
  description = "Grafana LokiIAM role unique ID"
}

output "loki_service_account_role_arn" {
  value       = module.loki_eks_iam_role.service_account_role_arn
  description = "Grafana LokiIAM role ARN"
}

output "loki_service_account_policy_name" {
  value       = module.loki_eks_iam_role.service_account_policy_name
  description = "Grafana LokiIAM policy name"
}

output "loki_service_account_policy_id" {
  value       = module.loki_eks_iam_role.service_account_policy_id
  description = "Grafana LokiIAM policy ID"
}

output "loki_bucket_id" {
  value       = module.loki_s3_bucket.bucket_id
  description = "Grafana LokiS3 bucket name"
}

output "loki_bucket_arn" {
  value       = module.loki_s3_bucket.bucket_arn
  description = "Grafana LokiS3 bucket ARN"
}

output "tempo_metadata" {
  value       = local.tempo_enabled ? helm_release.tempo[0].metadata : null
  description = "Block status of the deployed tempo"
}

output "tempo_service_account_role_name" {
  value       = module.tempo_eks_iam_role.service_account_role_name
  description = "Grafana Tempto IAM role name"
}

output "tempo_service_account_role_unique_id" {
  value       = module.tempo_eks_iam_role.service_account_role_unique_id
  description = "Grafana Tempto IAM role unique ID"
}

output "tempo_service_account_role_arn" {
  value       = module.tempo_eks_iam_role.service_account_role_arn
  description = "Grafana Tempto IAM role ARN"
}

output "tempo_service_account_policy_name" {
  value       = module.tempo_eks_iam_role.service_account_policy_name
  description = "Grafana Tempto IAM policy name"
}

output "tempo_service_account_policy_id" {
  value       = module.tempo_eks_iam_role.service_account_policy_id
  description = "Grafana Tempto IAM policy ID"
}

output "tempo_bucket_id" {
  value       = module.tempo_s3_bucket.bucket_id
  description = "Grafana Tempto S3 bucket name"
}

output "tempo_bucket_arn" {
  value       = module.tempo_s3_bucket.bucket_arn
  description = "Grafana Tempto S3 bucket ARN"
}

output "argo_events_metadata" {
  value       = local.argo_events_enabled ? helm_release.argo_events[0].metadata : null
  description = "Block status of the deployed Argo Events"
}

output "argo_rollouts_metadata" {
  value       = local.argo_rollouts_enabled ? helm_release.argo_rollouts[0].metadata : null
  description = "Block status of the deployed Argo Rollouts"
}

output "argo_workflows_metadata" {
  value       = local.argo_workflows_enabled ? helm_release.argo_workflows[0].metadata : null
  description = "Block status of the deployed Argo Workflows"
}

output "argocd_metadata" {
  value       = local.argocd_enabled ? helm_release.argocd[0].metadata : null
  description = "Block status of the deployed ArgoCD"
}

output "argocd_applicationset_metadata" {
  value       = local.argocd_applicationset_enabled ? helm_release.argocd_applicationset[0].metadata : null
  description = "Block status of the deployed ArgoCD ApplicationSet"
}

output "argocd_image_updater_metadata" {
  value       = local.argocd_image_updater_enabled ? helm_release.argocd_image_updater[0].metadata : null
  description = "Block status of the deployed ArgoCD Image Updater"
}

output "argocd_notifications_metadata" {
  value       = local.argocd_notifications_enabled ? helm_release.argocd_notifications[0].metadata : null
  description = "Block status of the deployed ArgoCD Notifications"
}

output "linkerd2_metadata" {
  value       = local.linkerd2_enabled ? helm_release.linkerd2[0].metadata : null
  description = "Block status of the deployed Linkerd2"
}
