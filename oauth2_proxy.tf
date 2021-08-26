locals {
  oauth2_proxy_enabled = module.this.enabled && contains(var.apps_to_install, "oauth2_proxy")
  oauth2_proxy_helm_default_params = {
    repository      = "https://oauth2-proxy.github.io/manifests"
    chart           = "oauth2-proxy"
    version         = "4.2.0"
    override_values = ""
  }
  oauth2_proxy_helm_default_values = {
    "fullnameOverride" = "${local.oauth2_proxy["name"]}"
    "metrics" = {
      "enabled" = true
      "port"    = 44180
      "servicemonitor" = {
        "enabled"            = true
        "interval"           = "30s"
        "namespace"          = "monitoring"
        "prometheusInstance" = "default"
        "scrapeTimeout"      = "10s"
      }
    }
    "resources" = {
      "limits" = {
        "cpu"    = "100m"
        "memory" = "100Mi"
      }
      "requests" = {
        "cpu"    = "50m"
        "memory" = "50Mi"
      }
    }
    "sessionStorage" = {
      "type" = "cookie"
    }
  }
  oauth2_proxy = defaults(var.oauth2_proxy, merge(local.helm_default_params, local.oauth2_proxy_helm_default_params))
}

data "utils_deep_merge_yaml" "oauth2_proxy" {
  count = local.oauth2_proxy_enabled ? 1 : 0

  input = [
    yamlencode(local.oauth2_proxy_helm_default_values),
    local.oauth2_proxy["override_values"]
  ]
}

resource "helm_release" "oauth2_proxy" {
  count = local.oauth2_proxy_enabled ? 1 : 0

  name              = local.oauth2_proxy["name"]
  repository        = local.oauth2_proxy["repository"]
  chart             = local.oauth2_proxy["chart"]
  version           = local.oauth2_proxy["version"]
  namespace         = local.oauth2_proxy["namespace"]
  max_history       = local.oauth2_proxy["max_history"]
  create_namespace  = local.oauth2_proxy["create_namespace"]
  dependency_update = local.oauth2_proxy["dependency_update"]
  reuse_values      = local.oauth2_proxy["reuse_values"]
  wait              = local.oauth2_proxy["wait"]
  timeout           = local.oauth2_proxy["timeout"]
  values            = [one(data.utils_deep_merge_yaml.oauth2_proxy[*].output)]

  depends_on = [
    helm_release.node_local_dns,
    helm_release.cert_manager,
    helm_release.external_dns,
    helm_release.kube_prometheus_stack,
    helm_release.ingress_nginx,
  ]
}
