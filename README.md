# terraform-aws-eks-cluster-bootstrap
![](https://github.com/actions/hello-world/workflows/.github/workflows/main.yml/badge.svg)

Terraform module to deploy curated helm releases on EKS cluster.

NOTE: This module is under heavy development.

## Usage

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 3.0 |
| helm | >= 2 |
| kubernetes | >= 2 |
| utils | >= 0.14.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |
| helm | >= 2 |
| kubernetes | >= 2 |
| utils | >= 0.14.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks\_cluster\_id | EKS cluster ID | `string` | n/a | yes |
| actions\_runner\_controller | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "actions-runner-controller",<br>  "namespace": "cicd"<br>}</pre> | no |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| apps\_to\_install | A list of apps which will be installed | `list(string)` | <pre>[<br>  "cert_manager",<br>  "cert_manager_issuers",<br>  "cluster_autoscaler",<br>  "victoria_metrics",<br>  "ebs_csi_driver",<br>  "node_local_dns",<br>  "kube_prometheus_stack",<br>  "aws_node_termination_handler",<br>  "external_dns",<br>  "ingress_nginx",<br>  "vault",<br>  "actions_runner_controller",<br>  "velero",<br>  "oauth2_proxy",<br>  "node_problem_detector",<br>  "argo_events",<br>  "argo_rollouts",<br>  "argo_workflows",<br>  "argocd",<br>  "argocd_applicationset",<br>  "argocd_image_updater",<br>  "argocd_notifications",<br>  "sentry",<br>  "loki",<br>  "tempo"<br>]</pre> | no |
| argo\_events | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argo-events",<br>  "namespace": "argo"<br>}</pre> | no |
| argo\_rollouts | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argo-rollouts",<br>  "namespace": "argo"<br>}</pre> | no |
| argo\_workflows | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argo-workflows",<br>  "namespace": "argo"<br>}</pre> | no |
| argocd | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argocd",<br>  "namespace": "argo"<br>}</pre> | no |
| argocd\_applicationset | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argocd-applicationset",<br>  "namespace": "argo"<br>}</pre> | no |
| argocd\_image\_updater | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argocd-image-updater",<br>  "namespace": "argo"<br>}</pre> | no |
| argocd\_notifications | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "argocd-notifications",<br>  "namespace": "argo"<br>}</pre> | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| aws\_node\_termination\_handler | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "aws-node-termination-handler",<br>  "namespace": "kube-system"<br>}</pre> | no |
| cert\_manager | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "cert-manager",<br>  "namespace": "cert-manager"<br>}</pre> | no |
| cert\_manager\_issuers | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "cert-manager-issuers",<br>  "namespace": "cert-manager"<br>}</pre> | no |
| cluster\_autoscaler | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "cluster-autoscaler",<br>  "namespace": "kube-system"<br>}</pre> | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| ebs\_csi\_driver | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "ebs-csi-driver",<br>  "namespace": "kube-system"<br>}</pre> | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| external\_dns | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "external-dns",<br>  "namespace": "infra"<br>}</pre> | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| ingress\_nginx | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "ingress-nginx",<br>  "namespace": "infra"<br>}</pre> | no |
| kube\_prometheus\_stack | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "kube-prometheus-stack",<br>  "namespace": "monitoring"<br>}</pre> | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `"lower"` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| loki | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "loki",<br>  "namespace": "monitoring"<br>}</pre> | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| node\_local\_dns | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "node-local-dns",<br>  "namespace": "kube-system"<br>}</pre> | no |
| node\_problem\_detector | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "node-problem-detector",<br>  "namespace": "monitoring"<br>}</pre> | no |
| oauth2\_proxy | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "oauth2-proxy",<br>  "namespace": "infra"<br>}</pre> | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| sentry | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "sentry",<br>  "namespace": "sentry"<br>}</pre> | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| tempo | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "tempo",<br>  "namespace": "monitoring"<br>}</pre> | no |
| vault | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "vault",<br>  "namespace": "vault"<br>}</pre> | no |
| velero | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "velero",<br>  "namespace": "velero"<br>}</pre> | no |
| victoria\_metrics | n/a | <pre>object({<br>    name              = string<br>    namespace         = string<br>    repository        = optional(string)<br>    chart             = optional(string)<br>    version           = optional(string)<br>    override_values   = optional(string)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "name": "monitoring",<br>  "namespace": "monitoring"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| actions\_runner\_controller\_metadata | Block status of the deployed GitHub Actions runner controller |
| aws\_node\_termination\_handler\_metadata | Block status of the deployed AWS Node Termination Handler |
| cert\_manager\_metadata | Block status of the deployed Cert-Manager |
| cluster\_autoscaler\_metadata | Block status of the deployed Cluster-Autoscaler |
| cluster\_autoscaler\_service\_account\_policy\_id | Cluster-Autoscaler IAM policy ID |
| cluster\_autoscaler\_service\_account\_policy\_name | Cluster-Autoscaler IAM policy name |
| cluster\_autoscaler\_service\_account\_role\_arn | Cluster-Autoscaler IAM role ARN |
| cluster\_autoscaler\_service\_account\_role\_name | Cluster-Autoscaler IAM role name |
| cluster\_autoscaler\_service\_account\_role\_unique\_id | Cluster-Autoscaler IAM role unique ID |
| ebs\_csi\_driver\_metadata | Block status of the deployed EBS CSI driver |
| ebs\_csi\_driver\_service\_account\_policy\_id | EBS CSI driver IAM policy ID |
| ebs\_csi\_driver\_service\_account\_policy\_name | EBS CSI driver IAM policy name |
| ebs\_csi\_driver\_service\_account\_role\_arn | EBS CSI driver IAM role ARN |
| ebs\_csi\_driver\_service\_account\_role\_name | EBS CSI driver IAM role name |
| ebs\_csi\_driver\_service\_account\_role\_unique\_id | EBS CSI driver IAM role unique ID |
| external\_dns\_metadata | Block status of the deployed External DNS |
| ingress\_nginx\_metadata | Block status of the deployed Ingress Nginx |
| kube\_prometheus\_stack\_metadata | Block status of the deployed Kube Prometheus Stack |
| node\_local\_dns\_metadata | Block status of the deployed Node Local DNS |
| oauth2\_proxy\_metadata | Block status of the deployed OAuth2 proxy |
| vault\_metadata | Block status of the deployed Vault |
| vault\_service\_account\_policy\_id | Vault IAM policy ID |
| vault\_service\_account\_policy\_name | Vault IAM policy name |
| vault\_service\_account\_role\_arn | Vault IAM role ARN |
| vault\_service\_account\_role\_name | Vault IAM role name |
| vault\_service\_account\_role\_unique\_id | Vault IAM role unique ID |
| velero\_metadata | Block status of the deployed Velero |
| velero\_service\_account\_policy\_id | Velero IAM policy ID |
| velero\_service\_account\_policy\_name | Velero IAM policy name |
| velero\_service\_account\_role\_arn | Velero IAM role ARN |
| velero\_service\_account\_role\_name | Velero IAM role name |
| velero\_service\_account\_role\_unique\_id | Velero IAM role unique ID |
| victoria\_metrics\_metadata | Block status of the deployed VictoriaMetrics |

<!--- END_TF_DOCS --->

## License
The Apache-2.0 license
