# terraform-aws-eks-cluster-bootstrap
![](https://github.com/actions/hello-world/workflows/.github/workflows/main.yml/badge.svg)

Terraform module to deploy curated helm releases on EKS cluster.

NOTE: This module is under heavy development

## Usage

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 3.0 |
| helm | >= 2 |
| kubernetes | >= 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |
| helm | >= 2 |
| kubernetes | >= 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks\_cluster\_id | EKS cluster ID | `string` | n/a | yes |
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| apps\_to\_install | A list of apps which will be installed | `list(string)` | <pre>[<br>  "cert_manager",<br>  "cert_manager_issuers",<br>  "cluster_autoscaler",<br>  "victoria_metrics",<br>  "ebs_csi_driver",<br>  "node_local_dns",<br>  "kube_prometheus_stack",<br>  "aws_node_termination_handler",<br>  "external_dns",<br>  "ingress_nginx"<br>]</pre> | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| aws\_node\_termination\_handler | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "aws-node-termination-handler",<br>  "name": "aws-node-termination-handler",<br>  "namespace": "kube-system",<br>  "repository": "https://aws.github.io/eks-charts",<br>  "values": [],<br>  "version": "0.15.2"<br>}</pre> | no |
| cert\_manager | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "cert-manager",<br>  "name": "cert-manager",<br>  "namespace": "cert-manager",<br>  "repository": "https://charts.jetstack.io",<br>  "values": [],<br>  "version": "1.5.0"<br>}</pre> | no |
| cert\_manager\_issuers | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "cert-manager-issuers",<br>  "name": "cert-manager-issuers",<br>  "namespace": "cert-manager",<br>  "repository": "https://charts.adfinis.com",<br>  "values": [],<br>  "version": "0.2.2"<br>}</pre> | no |
| cluster\_autoscaler | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "cluster-autoscaler",<br>  "name": "cluster-autoscaler",<br>  "namespace": "kube-system",<br>  "repository": "https://kubernetes.github.io/autoscaler",<br>  "values": [],<br>  "version": "9.7.0"<br>}</pre> | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| ebs\_csi\_driver | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "ebs-csi-driver",<br>  "name": "ebs-csi",<br>  "namespace": "kube-system",<br>  "repository": "https://kubernetes-sigs.github.io/aws-ebs-csi-driver",<br>  "values": [],<br>  "version": "2.1.0"<br>}</pre> | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| external\_dns | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "external-dns",<br>  "name": "external-dns",<br>  "namespace": "infra",<br>  "repository": "https://charts.bitnami.com/bitnami",<br>  "values": [],<br>  "version": "1.1.2"<br>}</pre> | no |
| id\_length\_limit | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| ingress\_nginx | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "ingress-nginx",<br>  "name": "ingress-nginx",<br>  "namespace": "infra",<br>  "repository": "https://kubernetes.github.io/ingress-nginx",<br>  "values": [],<br>  "version": "3.35.0"<br>}</pre> | no |
| kube\_prometheus\_stack | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "kube-prometheus-stack",<br>  "name": "kube-prometheus-stack",<br>  "namespace": "monitoring",<br>  "repository": "https://prometheus-community.github.io/helm-charts",<br>  "values": [],<br>  "version": "17.2.2"<br>}</pre> | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `"lower"` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| node\_local\_dns | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "node-local-dns",<br>  "name": "node-local-dns",<br>  "namespace": "kube-system",<br>  "repository": "https://lablabs.github.io/k8s-nodelocaldns-helm/",<br>  "values": [],<br>  "version": "1.3.2"<br>}</pre> | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| victoria\_metrics | n/a | <pre>object({<br>    name              = string<br>    repository        = string<br>    chart             = string<br>    version           = string<br>    namespace         = string<br>    values            = list(any)<br>    max_history       = optional(number)<br>    create_namespace  = optional(bool)<br>    dependency_update = optional(bool)<br>    reuse_values      = optional(bool)<br>    wait              = optional(bool)<br>    timeout           = optional(number)<br>  })</pre> | <pre>{<br>  "chart": "victoria-metrics-k8s-stack",<br>  "name": "monitoring",<br>  "namespace": "monitoring",<br>  "repository": "https://victoriametrics.github.io/helm-charts",<br>  "values": [],<br>  "version": "1.5.0"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_node\_termination\_handler\_metadata | Block status of the deployed victoria-metrics. |
| cert\_manager\_metadata | Block status of the deployed cert-manager. |
| cluster\_autoscaler\_metadata | Block status of the deployed cluster-autoscaler. |
| cluster\_autoscaler\_service\_account\_policy\_id | IAM policy ID |
| cluster\_autoscaler\_service\_account\_policy\_name | IAM policy name |
| cluster\_autoscaler\_service\_account\_role\_arn | IAM role ARN |
| cluster\_autoscaler\_service\_account\_role\_name | IAM role name |
| cluster\_autoscaler\_service\_account\_role\_unique\_id | IAM role unique ID |
| ebs\_csi\_driver\_metadata | Block status of the deployed cluster-autoscaler. |
| ebs\_csi\_driver\_service\_account\_policy\_id | IAM policy ID |
| ebs\_csi\_driver\_service\_account\_policy\_name | IAM policy name |
| ebs\_csi\_driver\_service\_account\_role\_arn | IAM role ARN |
| ebs\_csi\_driver\_service\_account\_role\_name | IAM role name |
| ebs\_csi\_driver\_service\_account\_role\_unique\_id | IAM role unique ID |
| external\_dns\_metadata | Block status of the deployed victoria-metrics. |
| ingress\_nginx\_metadata | Block status of the deployed victoria-metrics. |
| kube\_dns\_ip | n/a |
| kube\_prometheus\_stack\_metadata | Block status of the deployed victoria-metrics. |
| node\_local\_dns\_metadata | Block status of the deployed victoria-metrics. |
| victoria\_metrics\_metadata | Block status of the deployed victoria-metrics. |

<!--- END_TF_DOCS --->

## License
The Apache-2.0 license
