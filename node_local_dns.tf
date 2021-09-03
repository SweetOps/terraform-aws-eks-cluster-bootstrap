locals {
  node_local_dns_enabled = module.this.enabled && contains(var.apps_to_install, "node_local_dns")
  node_local_dns_helm_default_params = {
    repository      = "https://lablabs.github.io/k8s-nodelocaldns-helm/"
    chart           = "node-local-dns"
    version         = "1.3.2"
    override_values = ""
  }
  node_local_dns = defaults(var.node_local_dns, merge(local.helm_default_params, local.node_local_dns_helm_default_params))
  node_local_dns_helm_default_values = {
    "fullnameOverride" = "${local.node_local_dns["name"]}"
    "Corefile"         = <<-EOT
  cluster.local:53 {
      errors
      cache {
              success 9984 30
              denial 9984 5
      }
      reload
      loop
      bind 169.254.20.10 ${one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip)}
      forward . __PILLAR__CLUSTER__DNS__ {
              force_tcp
      }
      prometheus :9253
      health 169.254.20.10:8080
      }
  in-addr.arpa:53 {
      errors
      cache 30
      reload
      loop
      bind 169.254.20.10 ${one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip)}
      forward . __PILLAR__CLUSTER__DNS__ {
              force_tcp
      }
      prometheus :9253
      }
  ip6.arpa:53 {
      errors
      cache 30
      reload
      loop
      bind 169.254.20.10 ${one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip)}
      forward . __PILLAR__CLUSTER__DNS__ {
              force_tcp
      }
      prometheus :9253
      }
  .:53 {
      errors
      cache 30
      reload
      loop
      bind 169.254.20.10 ${one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip)}
      forward . __PILLAR__UPSTREAM__SERVERS__
      prometheus :9253
      }
  EOT
    "config" = {
      "localDnsIp" = "169.254.20.10"
    }
    "image" = {
      "args" = {
        "setupIptables" = true
      }
    }
  }
}

data "utils_deep_merge_yaml" "node_local_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  input = [
    yamlencode(local.node_local_dns_helm_default_values),
    local.node_local_dns["override_values"]
  ]
}

data "kubernetes_service" "kube_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"
  }
}

resource "helm_release" "node_local_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  name              = local.node_local_dns["name"]
  repository        = local.node_local_dns["repository"]
  chart             = local.node_local_dns["chart"]
  version           = local.node_local_dns["version"]
  namespace         = local.node_local_dns["namespace"]
  max_history       = local.node_local_dns["max_history"]
  create_namespace  = local.node_local_dns["create_namespace"]
  dependency_update = local.node_local_dns["dependency_update"]
  reuse_values      = local.node_local_dns["reuse_values"]
  wait              = local.node_local_dns["wait"]
  timeout           = local.node_local_dns["timeout"]
  values            = [one(data.utils_deep_merge_yaml.node_local_dns[*].output)]

  depends_on = [
    helm_release.calico,
    data.kubernetes_service.kube_dns
  ]
}
