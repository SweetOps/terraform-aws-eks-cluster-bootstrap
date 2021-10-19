locals {
  kube_dns_svc           = "kube-dns"
  kube_dns_ip            = local.node_local_dns_enabled ? one(data.kubernetes_service.kube_dns[*].spec[0].cluster_ip) : ""
  node_local_dns_enabled = module.this.enabled && contains(var.apps_to_install, "node_local_dns")
  node_local_dns         = defaults(var.node_local_dns, merge(local.helm_default_params, local.node_local_dns_helm_default_params))
  node_local_dns_helm_default_params = {
    repository      = "https://sweetops.github.io/helm-charts"
    chart           = "node-local-dns"
    version         = "0.1.0"
    override_values = ""
  }

  node_local_dns_helm_default_values = {
    "config" = {
      "localDnsIp" = "169.254.20.10"
      "kubeDnsIp"  = local.kube_dns_ip
      "zones" = [
        {
          "plugins" = {
            "cache" = {
              "denial" = {
                "size" = 0
                "ttl"  = 1
              }
              "parameters"  = 30
              "prefetch"    = {}
              "serve_stale" = false
              "success" = {
                "size" = 9984
                "ttl"  = 30
              }
            }
            "debug"  = false
            "errors" = true
            "forward" = {
              "expire"       = ""
              "force_tcp"    = false
              "health_check" = ""
              "max_fails"    = ""
              "parameters"   = "__PILLAR__CLUSTER__DNS__"
              "policy"       = ""
              "prefer_udp"   = false
            }
            "health" = {
              "port" = 8080
            }
            "log" = {
              "classes" = "all"
              "format"  = "combined"
            }
            "prometheus" = true
            "reload"     = true
          }
          "zone" = "cluster.local:53"
        },
        {
          "plugins" = {
            "cache" = {
              "parameters" = 30
            }
            "debug"  = false
            "errors" = true
            "forward" = {
              "force_tcp"  = false
              "parameters" = "__PILLAR__CLUSTER__DNS__"
            }
            "health" = {
              "port" = 8080
            }
            "log" = {
              "classes" = "all"
              "format"  = "combined"
            }
            "prometheus" = true
            "reload"     = true
          }
          "zone" = "ip6.arpa:53"
        },
        {
          "plugins" = {
            "cache" = {
              "parameters" = 30
            }
            "debug"  = false
            "errors" = true
            "forward" = {
              "force_tcp"  = false
              "parameters" = "__PILLAR__CLUSTER__DNS__"
            }
            "health" = {
              "port" = 8080
            }
            "log" = {
              "classes" = "all"
              "format"  = "combined"
            }
            "prometheus" = true
            "reload"     = true
          }
          "zone" = "in-addr.arpa:53"
        },
        {
          "plugins" = {
            "cache" = {
              "parameters"  = 30
              "serve_stale" = false
            }
            "debug"  = false
            "errors" = true
            "forward" = {
              "expire"       = ""
              "force_tcp"    = false
              "health_check" = ""
              "max_fails"    = ""
              "parameters"   = "__PILLAR__UPSTREAM__SERVERS__"
              "policy"       = ""
              "prefer_udp"   = false
            }
            "health" = {
              "port" = 8080
            }
            "log" = {
              "classes" = "all"
              "format"  = "combined"
            }
            "prometheus" = true
            "reload"     = true
          }
          "zone" = ".:53"
        },
      ]
    }
    "fullnameOverride" = local.node_local_dns["name"]
    "image" = {
      "args" = {
        "setupIptables" = true
        "skipTeardown"  = false
      }
    }
    "serviceMonitor" = {
      "enabled" = true
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
    name      = local.kube_dns_svc
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
    kubectl_manifest.prometheus_operator_crds
  ]
}
