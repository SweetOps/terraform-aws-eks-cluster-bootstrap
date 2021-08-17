locals {
  node_local_dns_enabled = module.this.enabled && contains(var.apps_to_install, "node_local_dns")
  node_local_dns_values  = length(var.node_local_dns["values"]) > 0 ? var.node_local_dns["values"] : [yamlencode(local.node_local_dns_default_values)]
  node_local_dns_default_values = {
    "Corefile" = <<-EOT
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

data "kubernetes_service" "kube_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  metadata {
    name      = "kube-dns"
    namespace = "kube-system"
  }
}

output "kube_dns_ip" {
  value = one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip)
}

resource "helm_release" "node_local_dns" {
  count = local.node_local_dns_enabled ? 1 : 0

  name              = var.node_local_dns["name"]
  repository        = var.node_local_dns["repository"]
  chart             = var.node_local_dns["chart"]
  version           = var.node_local_dns["version"]
  namespace         = var.node_local_dns["namespace"]
  max_history       = var.node_local_dns["max_history"]
  create_namespace  = var.node_local_dns["create_namespace"]
  dependency_update = var.node_local_dns["dependency_update"]
  values            = local.node_local_dns_values

  set {
    name  = "fullnameOverride"
    value = var.node_local_dns["name"]
  }

  depends_on = [
    helm_release.kube_prometheus_stack,
    data.kubernetes_service.kube_dns
  ]
}
