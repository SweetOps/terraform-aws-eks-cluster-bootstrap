locals {
  cert_manager_enabled = module.this.enabled && contains(var.apps_to_install, "cert_manager")
  cert_manager_helm_default_params = {
    chart           = "cert-manager"
    repository      = "https://charts.jetstack.io"
    version         = "1.5.0"
    override_values = ""
  }
  cert_manager_helm_default_values = {
    "fullnameOverride" = "${local.cert_manager["name"]}"
    "installCRDs"      = true
    "prometheus" = {
      "enabled" = true
      "servicemonitor" = {
        "enabled" = true
      }
    }
  }
  cert_manager                 = defaults(var.cert_manager, merge(local.helm_default_params, local.cert_manager_helm_default_params))
  cert_manager_issuers_enabled = module.this.enabled && contains(var.apps_to_install, "cert_manager_issuers")

  cert_manager_issuers_helm_default_params = {
    repository      = "https://charts.adfinis.com"
    chart           = "cert-manager-issuers"
    version         = "0.2.2"
    override_values = ""
  }
  cert_manager_issuers_helm_default_values = {
    "fullnameOverride" = "${local.cert_manager_issuers["name"]}"
  }
  cert_manager_issuers = defaults(var.cert_manager_issuers, merge(local.helm_default_params, local.cert_manager_issuers_helm_default_params))
}

data "utils_deep_merge_yaml" "cert_manager" {
  count = local.cert_manager_enabled ? 1 : 0

  input = [
    yamlencode(local.cert_manager_helm_default_values),
    local.cert_manager["override_values"]
  ]
}

resource "helm_release" "cert_manager" {
  count = local.cert_manager_enabled ? 1 : 0

  name              = local.cert_manager["name"]
  repository        = local.cert_manager["repository"]
  chart             = local.cert_manager["chart"]
  version           = local.cert_manager["version"]
  namespace         = local.cert_manager["namespace"]
  max_history       = local.cert_manager["max_history"]
  create_namespace  = local.cert_manager["create_namespace"]
  dependency_update = local.cert_manager["dependency_update"]
  reuse_values      = local.cert_manager["reuse_values"]
  wait              = local.cert_manager["wait"]
  timeout           = local.cert_manager["timeout"]
  values            = [one(data.utils_deep_merge_yaml.cert_manager[*].output)]

  depends_on = [
    helm_release.calico,
    helm_release.kube_prometheus_stack,
    helm_release.node_local_dns
  ]
}

data "utils_deep_merge_yaml" "cert_manager_issuers" {
  count = local.cert_manager_issuers_enabled ? 1 : 0

  input = [
    yamlencode(local.cert_manager_issuers_helm_default_values),
    local.cert_manager_issuers["override_values"]
  ]
}

resource "helm_release" "cert_manager_issuers" {
  count = local.cert_manager_issuers_enabled ? 1 : 0

  name              = local.cert_manager_issuers["name"]
  repository        = local.cert_manager_issuers["repository"]
  chart             = local.cert_manager_issuers["chart"]
  version           = local.cert_manager_issuers["version"]
  namespace         = local.cert_manager_issuers["namespace"]
  max_history       = local.cert_manager_issuers["max_history"]
  create_namespace  = local.cert_manager_issuers["create_namespace"]
  dependency_update = local.cert_manager_issuers["dependency_update"]
  reuse_values      = local.cert_manager_issuers["reuse_values"]
  wait              = local.cert_manager_issuers["wait"]
  timeout           = local.cert_manager_issuers["timeout"]
  values            = [one(data.utils_deep_merge_yaml.cert_manager_issuers[*].output)]

  depends_on = [
    helm_release.cert_manager
  ]
}
